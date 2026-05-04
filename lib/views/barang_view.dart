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

  getBarang() async {
    ResponseDataList response = await barangService.getBarang();
    if (response.status == true) {
      setState(() {
        listBarang = response.data as List<BarangModel>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Shop",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardView()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TambahBarangView(title: "Add Product"),
                ),
              ).then((_) => getBarang());
            },
          ),
        ],
      ),
      body: listBarang == null
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : listBarang!.isEmpty
              ? const Center(child: Text("No products yet"))
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: listBarang!.length,
                  itemBuilder: (context, index) {
                    final item = listBarang![index];
                    return GestureDetector(
                      onLongPress: () => _showMenu(item),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                child: Image.network(
                                  item.image ?? "",
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(color: Colors.grey[100]),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.nama_barang ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Rp ${item.harga?.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Stock: ${item.stok}",
                                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showMenu(BarangModel item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Update Product"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahBarangView(title: "Update", item: item),
                ),
              ).then((_) => getBarang());
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Delete Product", style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              var result = await AlertMessage().showAlertDialog(context);
              if (result != null && result['status'] == true) {
                var res = await barangService.hapusBarang(item.id);
                if (res.status == true) {
                  AlertMessage().showAlert(context, res.message, true);
                  getBarang();
                }
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
