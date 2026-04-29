import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toko_online/models/barang_model.dart';
import 'package:toko_online/services/barang_service.dart';
import 'package:toko_online/widgets/alert.dart';

class TambahBarangView extends StatefulWidget {
  final String title;
  final BarangModel? item;

  const TambahBarangView({
    super.key,
    required this.title,
    this.item,
  });

  @override
  State<TambahBarangView> createState() => _TambahBarangViewState();
}

class _TambahBarangViewState extends State<TambahBarangView> {
  BarangService barangService = BarangService();
  final formKey = GlobalKey<FormState>();

  TextEditingController namaBarang = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController stok = TextEditingController();
  TextEditingController deskripsi = TextEditingController();

  File? selectedImage;
  bool isLoading = false;

  /// 🔥 FIX PENTING supaya ga freeze
  bool isActive = true;

  /// 🔵 WARNA SAMA KAYAK REGISTER
  final Color primaryBlue = const Color(0xFF4C7DAF);
  final Color accentBlue = const Color(0xFF3A6EA5);
  final Color softBlue = const Color(0xFFEAF2FB);

  /// 🔵 STYLE INPUT
  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: accentBlue),
      prefixIcon: Icon(icon, color: accentBlue),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accentBlue),
      ),
    );
  }

  /// dispose supaya context aman
  @override
  void dispose() {
    isActive = false;
    namaBarang.dispose();
    harga.dispose();
    stok.dispose();
    deskripsi.dispose();
    super.dispose();
  }

  /// ambil gambar dari gallery
  Future getImage() async {
    setState(() => isLoading = true);

    var img = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (!isActive) return;

    if (img != null) {
      selectedImage = File(img.path);
    }

    setState(() => isLoading = false);
  }

  /// isi form jika update
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      namaBarang.text = widget.item!.nama_barang ?? "";
      harga.text = widget.item!.harga.toString();
      stok.text = widget.item!.stok.toString();
      deskripsi.text = widget.item!.deskripsi ?? "";
    }
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlue,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [

                    Text(
                      widget.item == null ? "Tambah Barang" : "Update Barang",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: namaBarang,
                      decoration: inputStyle("Nama Barang", Icons.shopping_bag),
                      validator: (v) => v!.isEmpty ? "Nama barang wajib diisi" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: harga,
                      keyboardType: TextInputType.number,
                      decoration: inputStyle("Harga", Icons.attach_money),
                      validator: (v) => v!.isEmpty ? "Harga wajib diisi" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: stok,
                      keyboardType: TextInputType.number,
                      decoration: inputStyle("Stok", Icons.inventory),
                      validator: (v) => v!.isEmpty ? "Stok wajib diisi" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: deskripsi,
                      decoration: inputStyle("Deskripsi", Icons.description),
                      validator: (v) => v!.isEmpty ? "Deskripsi wajib diisi" : null,
                    ),

                    const SizedBox(height: 16),

                    /// PILIH GAMBAR
                    TextButton(
                      onPressed: getImage,
                      child: Text("Pilih Gambar", style: TextStyle(color: primaryBlue)),
                    ),

                    if (selectedImage != null)
                      Image.file(selectedImage!, height: 150)
                    else if (isLoading)
                      const CircularProgressIndicator()
                    else
                      const Text("Belum memilih gambar"),

                    const SizedBox(height: 25),

                    /// ================= TOMBOL SIMPAN (FIX) =================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {

                          if (!formKey.currentState!.validate()) return;

                          var data = {
                            "nama_barang": namaBarang.text,
                            "harga": harga.text,
                            "stok": stok.text,
                            "deskripsi": deskripsi.text,
                          };

                          var result = await barangService.insertBarang(
                            data,
                            selectedImage,
                            widget.item?.id,
                          );

                          /// 🔥 WAJIB cek sebelum pakai context
                          if (!isActive) return;

                          if (result.status == true) {
                            AlertMessage().showAlert(context, result.message, true);
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, '/barang');
                          } else {
                            AlertMessage().showAlert(context, result.message, false);
                          }
                        },
                        child: const Text("Simpan"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}