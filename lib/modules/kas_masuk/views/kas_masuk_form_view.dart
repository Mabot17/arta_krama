import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arta_krama/modules/kas_masuk/controllers/kas_masuk_controller.dart';
import 'package:arta_krama/widgets/widget_appbar.dart';
import 'package:arta_krama/widgets/widget_textfield.dart';
import 'package:arta_krama/widgets/widget_combobox.dart';

class KasMasukFormView extends StatelessWidget {
  final KasMasukController controller = Get.find<KasMasukController>();
  final Color baseColor = const Color(0xFF32CD32);

  KasMasukFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WidgetAppBar(title: 'Form Kas Masuk'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
          children: [
            WidgetComboBox(
              label: "Jenis Kas",
              value: controller.jenisKas.value,
              items: const ['kas_masuk', 'kas_keluar'],
              onChanged: (val) {
                if (val != null) controller.jenisKas.value = val;
              },
              color: baseColor,
            ),
            const SizedBox(height: 12),
            WidgetTextField(
              label: "Jumlah (Rp)",
              icon: Icons.attach_money,
              controller: controller.jumlahKasController,
              color: baseColor,
              keyboard: TextInputType.number,
            ),
            const SizedBox(height: 12),
            WidgetTextField(
              label: "Tanggal (YYYY-MM-DD)",
              icon: Icons.calendar_today,
              controller: controller.tanggalKasController,
              color: baseColor,
              keyboard: TextInputType.datetime,
            ),
            const SizedBox(height: 12),
            WidgetComboBox(
              label: "Cara Pembayaran",
              value: controller.caraKas.value,
              items: const ['tunai', 'card'],
              onChanged: (val) {
                if (val != null) controller.caraKas.value = val;
              },
              color: baseColor,
            ),
            const SizedBox(height: 12),
            WidgetTextField(
              label: "No. Rekening (opsional)",
              icon: Icons.account_balance,
              controller: controller.norekKasController,
              color: baseColor,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.saveKas,
                style: ElevatedButton.styleFrom(
                  backgroundColor: baseColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Simpan", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
