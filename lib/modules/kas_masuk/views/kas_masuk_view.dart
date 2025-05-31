import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arta_krama/modules/kas_masuk/controllers/kas_masuk_controller.dart';
import 'package:arta_krama/widgets/widget_appbar.dart';

class KasMasukView extends StatelessWidget {
  final KasMasukController controller = Get.find<KasMasukController>();

  KasMasukView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WidgetAppBar(title: "Kas Masuk"),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        final items = controller.kasMasukList;
        if (items.isEmpty) {
          return const Center(
            child: Text("Belum ada data kas masuk.", style: TextStyle(fontSize: 16)),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF32CD32),
                  child: const Icon(Icons.attach_money, color: Colors.white),
                ),
                title: Text(
                  "Rp ${item.jumlah.toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tanggal: ${item.tanggal}"),
                    Text("Cara: ${item.cara} | No Rek: ${item.norek ?? '-'}"),
                  ],
                ),
                // Ganti trailing pada ListTile seperti ini:
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      controller.goToEditPage(item);
                    } else if (value == 'delete') {
                      Get.defaultDialog(
                        title: "Konfirmasi",
                        middleText: "Yakin ingin menghapus kas masuk ini?",
                        textConfirm: "Ya",
                        textCancel: "Tidak",
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          controller.deleteKas(item.id!);
                          Get.back();
                        },
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                  ],
                ),

              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.goToAddPage(),
        backgroundColor: const Color(0xFF32CD32),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
