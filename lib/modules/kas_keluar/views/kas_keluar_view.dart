import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:arta_krama/modules/kas_keluar/controllers/kas_keluar_controller.dart';
import 'package:arta_krama/widgets/widget_appbar.dart';

class KasKeluarView extends StatelessWidget {
  final KasKeluarController controller = Get.find<KasKeluarController>();

  KasKeluarView({super.key});

  final NumberFormat formatRupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WidgetAppBar(title: "Kas Keluar"),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        final items = controller.kasKeluarList;
        if (items.isEmpty) {
          return const Center(
            child: Text("Belum ada data Kas Keluar.", style: TextStyle(fontSize: 16)),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF32CD32),
                  child: Icon(
                    item.cara == 'tunai' ? Icons.money : Icons.compare_arrows,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        formatRupiah.format(item.jumlah),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tanggal: ${item.tanggal}",
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    if (item.cara == 'transfer')
                      Chip(
                        label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45, // batasi lebar chip agar tidak overflow
                          child: Text(
                            "No Rek: ${item.norek ?? '-'}",
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        avatar: const Icon(Icons.account_balance_wallet, size: 18),
                        backgroundColor: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      controller.goToEditPage(item);
                    } else if (value == 'delete') {
                      Get.defaultDialog(
                        title: "Konfirmasi",
                        middleText: "Yakin ingin menghapus Kas Keluar ini?",
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
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: const [
                          Icon(Icons.edit, color: Colors.black54),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: const [
                          Icon(Icons.delete, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Text('Hapus'),
                        ],
                      ),
                    ),
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
