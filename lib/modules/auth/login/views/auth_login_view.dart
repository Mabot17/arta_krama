import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:arta_krama/modules/auth/login/controllers/auth_login_controller.dart';

class LoginView extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  const SizedBox(height: 30),

                  // Username
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: const TextStyle(color: Color(0xFF32CD32)),
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF32CD32)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Color(0xFF32CD32)),
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFF32CD32)),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),

                  // Login
                  ElevatedButton(
                    onPressed: () {
                      controller.login(
                        usernameController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                    child: const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF32CD32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Forgot Password
                  TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFF32CD32))),
                  ),

                  // Register
                  TextButton(
                    onPressed: () {
                      controller.handleMenuLoginTap({'route': '/register'});
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(color: Color(0xFF32CD32), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // GEAR ICON di kanan atas
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Warna latar belakang kotak
                  borderRadius: BorderRadius.circular(12), // Sudut membulat
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Bayangan lembut
                      blurRadius: 6,
                      offset: Offset(0, 3), // Arah bayangan
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Color(0xFF32CD32)),
                  onPressed: () {
                    controller.handleMenuLoginTap({'route': '/setting'});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
