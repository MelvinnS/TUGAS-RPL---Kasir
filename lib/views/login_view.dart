import 'package:flutter/material.dart';
import 'package:toko_online/services/user.dart';
import 'package:toko_online/widgets/alert.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;
  bool showPass = true;

  final Color primaryBlue = const Color(0xFF4C7DAF);
  final Color accentBlue = const Color(0xFF3A6EA5);
  final Color softBlue = const Color(0xFFEAF2FB);

  InputDecoration inputStyle(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: accentBlue),
      prefixIcon: Icon(icon, color: accentBlue),
      suffixIcon: suffix,
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
        title: Text("Login"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/register');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),

                      TextFormField(
                        controller: email,
                        decoration: inputStyle("Email", Icons.email),
                        validator: (value) =>
                            value!.isEmpty ? "Email harus diisi" : null,
                      ),
                      SizedBox(height: 12),

                      TextFormField(
                        controller: password,
                        obscureText: showPass,
                        decoration: inputStyle(
                          "Password",
                          Icons.lock,
                          suffix: IconButton(
                            icon: Icon(
                              showPass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: accentBlue,
                            ),
                            onPressed: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Password harus diisi" : null,
                      ),
                      SizedBox(height: 24),

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
                              setState(() => isLoading = true);

                              var data = {
                                "email": email.text,
                                "password": password.text,
                              };

                              var result = await user.loginUser(data);

                              setState(() => isLoading = false);

                              AlertMessage().showAlert(
                                context,
                                result.message,
                                result.status == true,
                              );

                              if (result.status == true) {
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/dashboard',
                                  );
                                });
                              }
                            }
                          },
                          child: Text("Login", style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(color: primaryBlue),
              ),
            ),
        ],
      ),
    );
  }
}
