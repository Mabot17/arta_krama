import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arta_krama/modules/auth/login/controllers/auth_login_controller.dart';
import 'package:arta_krama/widgets/widget_textfield.dart';
import 'package:arta_krama/widgets/widget_combobox.dart';

class RegisterView extends StatelessWidget {
  final controller = Get.find<AuthController>();

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController noInduk = TextEditingController();
  final TextEditingController namaLengkap = TextEditingController();
  final TextEditingController noTelp = TextEditingController();
  final TextEditingController alamat = TextEditingController();
  final TextEditingController email = TextEditingController();

  final RxString jenisKelamin = 'Laki-laki'.obs;
  final RxString jobdesk = 'admin'.obs;

  final Color greenColor = const Color(0xFF32CD32);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Daftar Akun"),
        backgroundColor: greenColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              WidgetTextField(
                label: "Username",
                icon: Icons.person,
                controller: username,
                color: greenColor,
              ),
              WidgetTextField(
                label: "Password",
                icon: Icons.lock,
                controller: password,
                color: greenColor,
                isPassword: true,
              ),
              WidgetTextField(
                label: "No Induk",
                icon: Icons.badge,
                controller: noInduk,
                color: greenColor,
              ),
              WidgetTextField(
                label: "Nama Lengkap",
                icon: Icons.person_outline,
                controller: namaLengkap,
                color: greenColor,
              ),
              WidgetTextField(
                label: "No Telepon",
                icon: Icons.phone,
                controller: noTelp,
                keyboard: TextInputType.phone,
                color: greenColor,
              ),
              WidgetTextField(
                label: "Alamat",
                icon: Icons.home,
                controller: alamat,
                color: greenColor,
              ),
              WidgetTextField(
                label: "Email",
                icon: Icons.email,
                controller: email,
                keyboard: TextInputType.emailAddress,
                color: greenColor,
              ),
              const SizedBox(height: 10),

              // Jenis Kelamin
              Obx(() => WidgetComboBox(
                    label: "Jenis Kelamin",
                    color: greenColor,
                    value: jenisKelamin.value,
                    items: const ["Laki-laki", "Perempuan"],
                    onChanged: (val) => jenisKelamin.value = val!,
                  )),
              const SizedBox(height: 10),

              // Jobdesk
              Obx(() => WidgetComboBox(
                    label: "Jobdesk",
                    color: greenColor,
                    value: jobdesk.value,
                    items: const ["admin", "accounting"],
                    onChanged: (val) => jobdesk.value = val!,
                  )),
              const SizedBox(height: 30),

              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text("Daftar", style: TextStyle(fontSize: 16)),
                  onPressed: () {
                    controller.register({
                      'username': username.text,
                      'password': password.text,
                      'no_induk': noInduk.text,
                      'nama_lengkap': namaLengkap.text,
                      'no_telp': noTelp.text,
                      'alamat': alamat.text,
                      'email': email.text,
                      'jobdesk': jobdesk.value,
                      'jenis_kelamin': jenisKelamin.value,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
