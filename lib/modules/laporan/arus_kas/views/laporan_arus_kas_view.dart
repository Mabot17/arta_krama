import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:arta_krama/modules/laporan/arus_kas/models/laporan_arus_kas_model.dart';
import 'package:arta_krama/modules/laporan/arus_kas/controllers/laporan_arus_kas_controller.dart';
import 'package:arta_krama/widgets/widget_appbar.dart';

class ArusKasView extends StatelessWidget {
  final ArusKasController controller = Get.find<ArusKasController>();
  final NumberFormat formatRupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  ArusKasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WidgetAppBar(title: "Laporan Arus Kas"),
      body: Column(
        children: [
          // Bagian filter di baris atas (tanggal filter + search)
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  _buildDateFilter(context, controller.startDate.value, () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: controller.startDate.value,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) controller.setStartDate(picked);
                  }),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  _buildDateFilter(context, controller.endDate.value, () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: controller.endDate.value,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) controller.setEndDate(picked);
                  }),
                  const Spacer(),
                  // Tombol cari dengan IconButton yang jelas tombolnya (highlight ada)
                  Ink(
                    decoration: ShapeDecoration(
                      color: Colors.blue.shade100,
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () => controller.fetchData(),
                      icon: const Icon(Icons.search, color: Colors.blue),
                      tooltip: "Cari",
                    ),
                  ),
                ],
              ),
            );
          }),

          // Bagian saldo akhir + tombol export Excel di bawah filter, center
          Obx(() {
            final saldo = controller.getSaldoAkhir();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Saldo akhir dengan container rounded dan warna sesuai nilai saldo
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: saldo >= 0 ? Colors.green.shade100 : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          saldo >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                          color: saldo >= 0 ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Saldo Akhir: ${formatRupiah.format(saldo)}",
                          style: TextStyle(
                            color: saldo >= 0 ? Colors.green.shade900 : Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Tombol export Excel dengan IconButton dan container agar timbul (highlight)
                  Ink(
                    decoration: ShapeDecoration(
                      color: Colors.green.shade100,
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // TODO: panggil fungsi export excel di controller
                        controller.exportToCsv();
                      },
                      icon: const Icon(Icons.file_download, color: Colors.green),
                      tooltip: "Export Excel",
                    ),
                  ),
                ],
              ),
            );
          }),

          // List data arus kas
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final combinedList = controller.combinedList;
              if (combinedList.isEmpty) {
                return const Center(child: Text("Data arus kas kosong."));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: combinedList.length,
                itemBuilder: (context, index) {
                  final item = combinedList[index];
                  final isMasuk = item.isMasuk;
                  final warna = isMasuk ? Colors.green : Colors.red;
                  final bgColor = isMasuk ? Colors.green.shade50 : Colors.red.shade50;

                  return Align(
                    alignment: isMasuk ? Alignment.centerLeft : Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => _showDetailDialog(context, item, isMasuk),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              isMasuk ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatRupiah.format(item.jumlah),
                              style: TextStyle(
                                  color: warna, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(item.tanggal,
                                style: TextStyle(color: warna.withOpacity(0.7), fontSize: 12)),
                            if (item.keterangan != null && item.keterangan!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  item.keterangan!,
                                  style: TextStyle(color: warna.withOpacity(0.8), fontSize: 13),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter(BuildContext context, DateTime date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.date_range, size: 18, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              DateFormat('dd MMM yyyy').format(date),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, ArusKas item, bool isMasuk) {
    Color dialogColor = isMasuk ? Colors.green : Colors.redAccent;
    String title = isMasuk ? "Detail Kas Masuk" : "Detail Kas Keluar";

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            color: dialogColor,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 40),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
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
                  foregroundColor: dialogColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
          Expanded(
              flex: 3,
              child: Text("$label:",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600))),
          Expanded(flex: 5, child: Text(value, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
