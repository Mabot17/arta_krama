import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Obx(() => UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF32CD32), // warna dasar hijau
                ),
                accountName: Text(
                  controller.username.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                accountEmail: const Text(
                  "user@example.com",
                  style: TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
                ),
              )),
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xFF32CD32)),
            title: const Text(
              'Profil',
              style: TextStyle(color: Color(0xFF32CD32)),
            ),
            onTap: () {
              // Tambahkan aksi jika perlu
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFF32CD32)),
            title: const Text(
              'Pengaturan',
              style: TextStyle(color: Color(0xFF32CD32)),
            ),
            onTap: () {
              controller.handleMenuTap({'route': '/setting'});
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFFE6F4EA), // soft greenish background
                    title: const Text(
                      'Konfirmasi Logout',
                      style: TextStyle(color: Color(0xFF32CD32)),
                    ),
                    content: const Text(
                      'Apakah Anda yakin ingin logout?',
                      style: TextStyle(color: Color(0xFF212121)),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text('Batal', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.logout();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text('Ya, Logout', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
