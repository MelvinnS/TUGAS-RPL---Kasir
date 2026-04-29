import 'package:flutter/material.dart';
import 'package:toko_online/widgets/bottom_nav.dart';

class PesanView extends StatefulWidget {
  const PesanView({super.key});

  @override
  State<PesanView> createState() => _PesanViewState();
}

class _PesanViewState extends State<PesanView> {
  final Color primaryBlue = const Color(0xFF4C7DAF);
  final Color accentBlue = const Color(0xFF3A6EA5);
  final Color softBlue = const Color(0xFFEAF2FB);

  final List<Map<String, String>> historiPesanan = [
    {
      "nama": "Ushanka",
      "gambar": "assets/images/ushanka.jpg",
    },
    {
      "nama": "AK-47",
      "gambar": "assets/images/ak47.jpg",
    },
    {
      "nama": "Sukhoi SU-27",
      "gambar": "assets/images/sukhoi_su35.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlue,
      appBar: AppBar(
        title: const Text("Histori Pesanan"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: historiPesanan.length,
          itemBuilder: (context, index) {
            final item = historiPesanan[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item["gambar"]!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  item["nama"]!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                subtitle: Text(
                  "Pesanan berhasil",
                  style: TextStyle(
                    color: accentBlue,
                  ),
                ),
                trailing: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}
