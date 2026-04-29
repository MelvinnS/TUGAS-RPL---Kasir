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

  final Color primaryBlue = const Color(0xFF4C7DAF);
  final Color accentBlue = const Color(0xFF3A6EA5);
  final Color softBlue = const Color(0xFFEAF2FB);

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
      backgroundColor: softBlue,
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/login');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.dashboard,
                    size: 60,
                    color: primaryBlue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    nama ?? "-",
                    style: TextStyle(
                      fontSize: 18,
                      color: accentBlue,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Role: ${role ?? "-"}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(0),
    );
  }
}
