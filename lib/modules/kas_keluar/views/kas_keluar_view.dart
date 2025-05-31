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

  void showDetailDialog(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, color: Colors.white, size: 40),
              const SizedBox(height: 10),
              Text("Detail Kas Keluar", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              buildRow("Jumlah", formatRupiah.format(item.jumlah)),
              buildRow("Tanggal", item.tanggal),
              buildRow("Cara", '${item.cara[0].toUpperCase()}${item.cara.substring(1)}'),
              
              if (item.cara == 'transfer') buildRow("No Rek", item.norek ?? '-'),
              buildRow("Keterangan", item.keterangan ?? '-'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text("Tutup"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: Text("$label:", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
          Expanded(flex: 5, child: Text(value, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WidgetAppBar(title: "Kas Keluar"),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        final items = controller.kasKeluarList;
        if (items.isEmpty) {
          return const Center(
            child: Text("Belum ada data kas keluar.", style: TextStyle(fontSize: 16)),
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
                onTap: () => showDetailDialog(context, item),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.redAccent,
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
                          width: MediaQuery.of(context).size.width * 0.45,
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
