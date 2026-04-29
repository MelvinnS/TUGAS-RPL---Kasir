import 'package:toko_online/services/user.dart';
import 'package:toko_online/widgets/alert.dart';
import 'package:flutter/material.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController birthday = TextEditingController();

  List roleChoice = ["admin", "kasir"];
  String? role;

  final Color primaryBlue = const Color(0xFF4C7DAF);
  final Color accentBlue = const Color(0xFF3A6EA5);
  final Color softBlue = const Color(0xFFEAF2FB);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlue,
      appBar: AppBar(
        title: Text("Register User"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Create New User",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: name,
                    decoration: inputStyle("Name", Icons.person),
                    validator: (value) =>
                        value!.isEmpty ? "Nama harus diisi" : null,
                  ),
                  SizedBox(height: 12),

                  TextFormField(
                    controller: email,
                    decoration: inputStyle("Email", Icons.email),
                    validator: (value) =>
                        value!.isEmpty ? "Email harus diisi" : null,
                  ),
                  SizedBox(height: 12),

                  DropdownButtonFormField(
                    value: role,
                    decoration: inputStyle("Role", Icons.work),
                    items: roleChoice.map((r) {
                      return DropdownMenuItem(value: r, child: Text(r));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        role = value.toString();
                      });
                    },
                    validator: (value) =>
                        value == null ? "Role harus dipilih" : null,
                  ),
                  SizedBox(height: 12),

                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: inputStyle("Password", Icons.lock),
                    validator: (value) =>
                        value!.isEmpty ? "Password harus diisi" : null,
                  ),
                  SizedBox(height: 12),

                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          var data = {
                            "name": name.text,
                            "email": email.text,
                            "role": role,
                            "password": password.text,
                          };

                          var result = await user.registerUser(data);

                          AlertMessage().showAlert(
                            context,
                            result.message,
                            result.status == true,
                          );

                          if (result.status == true) {
                            name.clear();
                            email.clear();
                            password.clear();
                            setState(() {
                              role = null;
                            });
                          }
                        }
                      },
                      child: Text("Register", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sudah punya akun? ",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
