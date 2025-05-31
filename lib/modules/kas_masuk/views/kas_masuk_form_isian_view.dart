import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arta_krama/modules/kas_masuk/controllers/kas_masuk_controller.dart';
import 'package:arta_krama/modules/kas_masuk/models/kas_masuk_model.dart';
import 'package:arta_krama/widgets/widget_appbar.dart';
import 'package:arta_krama/widgets/widget_textfield.dart';

class KasMasukFormIsianView extends StatelessWidget {
  final KasMasukController controller = Get.find<KasMasukController>();
  final _formKey = GlobalKey<FormState>();

  KasMasukFormIsianView({super.key});

  @override
  Widget build(BuildContext context) {
    final KasMasuk? kas = Get.arguments;

    if (kas != null && controller.editingKas == null) {
      controller.editingKas = kas;
      controller.jumlahKasController.text = kas.jumlah.toString();
      controller.tanggalKasController.text = kas.tanggal;
      controller.caraKas.value = kas.cara;
      controller.norekKasController.text = kas.norek ?? '';
    }

    return Scaffold(
      appBar: WidgetAppBar(title: kas == null ? "Tambah Kas Masuk" : "Edit Kas Masuk"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              WidgetTextField(
                label: "Jumlah (Rp)",
                icon: Icons.attach_money,
                controller: controller.jumlahKasController,
                color: const Color(0xFF32CD32),
                keyboard: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  if (double.tryParse(value) == null) return 'Masukkan angka valid';
                  return null;
                },
              ),

              WidgetTextField(
                label: "Tanggal",
                icon: Icons.calendar_today,
                controller: controller.tanggalKasController,
                color: const Color(0xFF32CD32),
                readOnly: true,
                validator: (value) => (value == null || value.isEmpty) ? 'Wajib diisi' : null,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.tryParse(controller.tanggalKasController.text) ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    controller.tanggalKasController.text = picked.toIso8601String().split('T').first;
                  }
                },
              ),

              // Radio pilihan cara kas
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text("Cara Kas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ListTile(
                    title: const Text("Tunai"),
                    leading: Radio<String>(
                      value: "tunai",
                      groupValue: controller.caraKas.value,
                      onChanged: (value) {
                        if (value != null) controller.caraKas.value = value;
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text("Transfer"),
                    leading: Radio<String>(
                      value: "transfer",
                      groupValue: controller.caraKas.value,
                      onChanged: (value) {
                        if (value != null) controller.caraKas.value = value;
                      },
                    ),
                  ),
                ],
              )),

              // Field norek hanya tampil kalau transfer
              Obx(() => controller.caraKas.value == 'transfer'
                ? WidgetTextField(
                    label: "No Rekening (opsional)",
                    icon: Icons.account_balance,
                    controller: controller.norekKasController,
                    color: const Color(0xFF32CD32),
                  )
                : const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (kas != null) {
                      final updatedKas = KasMasuk(
                        id: kas.id,
                        jumlah: double.parse(controller.jumlahKasController.text),
                        tanggal: controller.tanggalKasController.text,
                        cara: controller.caraKas.value,
                        norek: controller.norekKasController.text.isEmpty ? null : controller.norekKasController.text,
                      );
                      await controller.updateKas(updatedKas);
                    } else {
                      await controller.saveKas();
                    }
                  }
                },
                icon: const Icon(Icons.save),
                label: Text(kas == null ? "Simpan" : "Perbarui"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF32CD32),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
