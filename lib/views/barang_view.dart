import 'package:flutter/material.dart';
import 'package:toko_online/models/barang_model.dart';
import 'package:toko_online/models/response_data_list.dart';
import 'package:toko_online/services/barang_service.dart';
import 'package:toko_online/views/dashboard.dart';
import 'package:toko_online/views/tambah_barang_view.dart';
import 'package:toko_online/widgets/alert.dart';

class BarangView extends StatefulWidget {
  const BarangView({super.key});

  @override
  State<BarangView> createState() => _BarangViewState();
}

class _BarangViewState extends State<BarangView> {
  BarangService barangService = BarangService();
  List<BarangModel>? listBarang;

  @override
  void initState() {
    super.initState();
    getBarang();
  }

  /// ================= GET DATA =================
  getBarang() async {
    ResponseDataList response = await barangService.getBarang();

    if (response.status == true) {
      setState(() {
        listBarang = response.data as List<BarangModel>;
      });
    }
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Katalog Barang"),

        /// 🔙 BACK KE DASHBOARD
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardView(),
              ),
            );
          },
        ),

        /// ➕ TAMBAH BARANG
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TambahBarangView(
                    title: "Tambah Barang",
                  ),
                ),
              ).then((_) => getBarang()); // refresh setelah balik
            },
          ),
        ],
      ),

      /// ================= LIST BARANG =================
      body: listBarang == null
          ? const Center(child: CircularProgressIndicator())
          : listBarang!.isEmpty
              ? const Center(child: Text("Belum ada barang"))
              : ListView.builder(
                  itemCount: listBarang!.length,
                  itemBuilder: (context, index) {
                    final item = listBarang![index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: ListTile(
                        leading: Image.network(
                          item.image ?? "",
                          width: 60,
                          fit: BoxFit.cover,
                        ),

                        title: Text(
                          item.nama_barang ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text("Rp ${item.harga?.toStringAsFixed(0)}"),
                            Text("Stok: ${item.stok}"),
                          ],
                        ),

                        /// ================= MENU CRUD =================
                        trailing: PopupMenuButton<String>(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "update",
                              child: Text("Update"),
                            ),
                            const PopupMenuItem(
                              value: "hapus",
                              child: Text("Hapus"),
                            ),
                          ],

                          onSelected: (String value) async {

                            /// ===== UPDATE =====
                            if (value == "update") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TambahBarangView(
                                    title: "Update Barang",
                                    item: item,
                                  ),
                                ),
                              ).then((_) => getBarang());
                            }

                            /// ===== HAPUS =====
                            if (value == "hapus") {
                              var result = await AlertMessage()
                                  .showAlertDialog(context);

                              if (result != null &&
                                  result['status'] == true) {
                                var res = await barangService
                                    .hapusBarang(item.id);

                                if (res.status == true) {
                                  AlertMessage().showAlert(
                                      context, res.message, true);
                                  getBarang();
                                } else {
                                  AlertMessage().showAlert(
                                      context, res.message, false);
                                }
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
