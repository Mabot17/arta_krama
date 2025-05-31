import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arta_krama/modules/kas_masuk/models/kas_masuk_model.dart';
import 'package:arta_krama/modules/kas_masuk/services/kas_masuk_service.dart';
import 'package:arta_krama/widgets/widget_snackbar.dart';
import 'package:arta_krama/routes/app_routes_constant.dart';

class KasMasukController extends GetxController {
  final KasMasukService _kasMasukService = KasMasukService();

  var kasMasukList = <KasMasuk>[].obs;

  // Observables
  var jenisKas = 'kas_masuk'.obs;
  var caraKas = 'tunai'.obs;

  // Controllers
  final TextEditingController jumlahKasController = TextEditingController();
  final TextEditingController tanggalKasController = TextEditingController();
  final TextEditingController norekKasController = TextEditingController();

  KasMasuk? editingKas;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await _kasMasukService.getAll();
      kasMasukList.assignAll(data);
    } catch (_) {
      WidgetSnackbar.warning("Peringatan", "Data kas masuk tidak ditemukan");
    }
  }

  void resetForm() {
    jumlahKasController.clear();
    tanggalKasController.clear();
    norekKasController.clear();
    caraKas.value = 'tunai';
    editingKas = null;
  }

  void setFormFromKas(KasMasuk kas) {
    editingKas = kas;
    jumlahKasController.text = kas.jumlah.toString();
    tanggalKasController.text = kas.tanggal;
    caraKas.value = kas.cara;
    norekKasController.text = kas.norek ?? '';
  }

  Future<void> saveKas() async {
    final jumlahText = jumlahKasController.text.trim();
    final tanggalText = tanggalKasController.text.trim();
    final norekText = norekKasController.text.trim();

    if (jumlahText.isEmpty || tanggalText.isEmpty) {
      WidgetSnackbar.danger("Error", "Jumlah dan Tanggal wajib diisi");
      return;
    }

    final jumlah = double.tryParse(jumlahText);
    if (jumlah == null) {
      WidgetSnackbar.danger("Error", "Jumlah tidak valid");
      return;
    }

    final kasData = {
      'kas_jenis': jenisKas.value,
      'kas_cara': caraKas.value,
      'kas_jumlah': jumlah,
      'kas_tanggal': tanggalText,
      'kas_norek': norekText.isNotEmpty ? norekText : null,
    };

    try {
      final success = await _kasMasukService.insert(kasData);
      if (success) {
        WidgetSnackbar.success("Berhasil", "Kas masuk berhasil ditambahkan");
        resetForm();
        await fetchData();
        Get.toNamed(AppRoutesConstants.kasMasuk);
      } else {
        WidgetSnackbar.danger("Gagal", "Data gagal ditambahkan");
      }
    } catch (e) {
      WidgetSnackbar.danger("Gagal", "Gagal menyimpan data");
    }
  }

  Future<void> updateKas(KasMasuk kas) async {
    try {
      final updatedKas = KasMasuk(
        id: kas.id,
        jumlah: double.parse(jumlahKasController.text),
        tanggal: tanggalKasController.text,
        cara: caraKas.value,
        norek: norekKasController.text.isNotEmpty ? norekKasController.text : null,
      );

      await _kasMasukService.update(updatedKas);
      WidgetSnackbar.success("Sukses", "Kas masuk berhasil diubah");

      resetForm();
      editingKas = null; // 🔁 pindahkan reset editingKas di sini
      await fetchData();
      Get.toNamed(AppRoutesConstants.kasMasuk);
    } catch (_) {
      WidgetSnackbar.danger("Gagal", "Gagal mengubah kas masuk");
    }
  }

  Future<void> deleteKas(int id) async {
    try {
      await _kasMasukService.delete(id);
      await fetchData();
      WidgetSnackbar.success("Sukses", "Data berhasil dihapus");
    } catch (_) {
      WidgetSnackbar.danger("Gagal", "Gagal menghapus data");
    }
  }

  void goToAddPage() {
    resetForm();
    Get.toNamed(AppRoutesConstants.kasMasukFormIsian);
  }

  void goToEditPage(KasMasuk kas) {
    setFormFromKas(kas);
    Get.toNamed(AppRoutesConstants.kasMasukFormIsian, arguments: kas);
  }
}
