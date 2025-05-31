import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arta_krama/modules/kas_masuk/controllers/kas_masuk_controller.dart';
import 'package:arta_krama/modules/kas_masuk/models/kas_masuk_model.dart';

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
      appBar: AppBar(
        title: Text(kas == null ? "Tambah Kas Masuk" : "Edit Kas Masuk"),
        backgroundColor: const Color(0xFF32CD32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: controller.jumlahKasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Jumlah (Rp)"),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  if (double.tryParse(value) == null) return 'Masukkan angka valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.tanggalKasController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Tanggal"),
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
              const SizedBox(height: 12),
              Obx(() => DropdownButtonFormField(
                value: controller.caraKas.value,
                items: ['tunai', 'transfer'].map((c) {
                  return DropdownMenuItem(value: c, child: Text(c.capitalize!));
                }).toList(),
                onChanged: (value) {
                  if (value != null) controller.caraKas.value = value.toString();
                },
                decoration: const InputDecoration(labelText: "Cara Kas"),
              )),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.norekKasController,
                decoration: const InputDecoration(labelText: "No Rekening (opsional)"),
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
