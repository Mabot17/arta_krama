import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:arta_krama/modules/auth/login/controllers/auth_login_controller.dart';
import 'package:arta_krama/widgets/widget_textfield.dart';

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
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                    const SizedBox(height: 30),

                    // Pakai WidgetTextField untuk username
                    WidgetTextField(
                      label: "Username",
                      icon: Icons.person,
                      controller: usernameController,
                      color: const Color(0xFF32CD32),
                    ),

                    // Password dengan isPassword true
                    WidgetTextField(
                      label: "Password",
                      icon: Icons.lock,
                      controller: passwordController,
                      color: const Color(0xFF32CD32),
                      isPassword: true,
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () {
                        controller.login(
                          usernameController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color(0xFF32CD32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Color(0xFF32CD32)),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        controller.handleMenuLoginTap({'route': '/register'});
                      },
                      child: const Text(
                        "Don't have an account? Register",
                        style: TextStyle(
                          color: Color(0xFF32CD32),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
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
