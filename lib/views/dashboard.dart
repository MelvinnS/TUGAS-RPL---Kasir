import 'package:flutter/material.dart';
import 'package:toko_online/models/user_login.dart';
import 'package:toko_online/widgets/bottom_nav.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  UserLogin userLogin = UserLogin();
  String? nama;
  String? role;

  getUserLogin() async {
    var user = await userLogin.getUserLogin();
    if (user.status != false) {
      setState(() {
        nama = user.nama_user;
        role = user.role;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(nama ?? "Profile", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => Navigator.popAndPushNamed(context, '/login'),
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFFEEEEEE),
            child: Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Text(
            "@${nama?.toLowerCase().replaceAll(' ', '_') ?? 'user'}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(role ?? "User", style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(height: 24),
          const Divider(thickness: 1),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(6, (index) => Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade50)),
                child: const Icon(Icons.grid_on, color: Colors.grey, size: 20),
              )),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNav(0),
    );
  }
}
