import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arta_krama/modules/kas_keluar/controllers/kas_keluar_controller.dart';
import 'package:arta_krama/modules/kas_keluar/models/kas_keluar_model.dart';
import 'package:arta_krama/widgets/widget_appbar.dart';
import 'package:arta_krama/widgets/widget_textfield.dart';

class KasKeluarFormIsianView extends StatelessWidget {
  final KasKeluarController controller = Get.find<KasKeluarController>();
  final _formKey = GlobalKey<FormState>();

  KasKeluarFormIsianView({super.key});

  @override
  Widget build(BuildContext context) {
    final KasKeluar? kas = Get.arguments;

    if (kas != null && controller.editingKas == null) {
      controller.editingKas = kas;
      controller.jumlahKasController.text = kas.jumlah.toString();
      controller.tanggalKasController.text = kas.tanggal;
      controller.caraKas.value = kas.cara;
      controller.norekKasController.text = kas.norek ?? '';
      controller.keteranganKasController.text = kas.keterangan ?? '';
    }

    return Scaffold(
      appBar: WidgetAppBar(title: kas == null ? "Tambah Kas Keluar" : "Edit Kas Keluar"),
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

              // Field Keterangan
              WidgetTextField(
                label: "Keterangan (opsional)",
                icon: Icons.note,
                controller: controller.keteranganKasController,
                color: const Color(0xFF32CD32),
                maxLines: 3,
              ),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (kas != null) {
                      final updatedKas = KasKeluar(
                        id: kas.id,
                        jumlah: double.parse(controller.jumlahKasController.text),
                        tanggal: controller.tanggalKasController.text,
                        cara: controller.caraKas.value,
                        norek: controller.norekKasController.text.isEmpty ? null : controller.norekKasController.text,
                        keterangan: controller.keteranganKasController.text,
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
