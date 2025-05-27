import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:arta_krama/modules/auth/login/controllers/auth_login_controller.dart';
import 'package:arta_krama/modules/home/controllers/home_controller.dart';

class LoginView extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController controller = Get.find<AuthController>();
  final HomeController _home_controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background warna putih agar bersih
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo atau gambar header (opsional)
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),

              const SizedBox(height: 30),

              // Username Field
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

              // Password Field
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

              // Login Button
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
                onPressed: () {
                  // TODO: Redirect to forgot password page
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Color(0xFF32CD32)),
                ),
              ),

              // Register Button
              TextButton(
                onPressed: () {
                    _home_controller.handleMenuTap({'route': '/register'});
                },
                child: const Text(
                  "Don't have an account? Register",
                  style: TextStyle(color: Color(0xFF32CD32), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
