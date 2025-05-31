import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arta_krama/modules/kas_keluar/models/kas_keluar_model.dart';
import 'package:arta_krama/modules/kas_keluar/services/kas_keluar_service.dart';
import 'package:arta_krama/widgets/widget_snackbar.dart';
import 'package:arta_krama/routes/app_routes_constant.dart';

class KasKeluarController extends GetxController {
  final KasKeluarService _kasKeluarService = KasKeluarService();

  var kasKeluarList = <KasKeluar>[].obs;

  // Observables
  var jenisKas = 'kas_keluar'.obs;
  var caraKas = 'tunai'.obs;

  // Controllers
  final TextEditingController jumlahKasController = TextEditingController();
  final TextEditingController tanggalKasController = TextEditingController();
  final TextEditingController norekKasController = TextEditingController();
  final TextEditingController keteranganKasController = TextEditingController();

  KasKeluar? editingKas;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await _kasKeluarService.getAll();
      kasKeluarList.assignAll(data);
    } catch (_) {
      WidgetSnackbar.warning("Peringatan", "Data Kas Keluar tidak ditemukan");
    }
  }

  void resetForm() {
    jumlahKasController.clear();
    tanggalKasController.clear();
    norekKasController.clear();
    keteranganKasController.clear();
    caraKas.value = 'tunai';
    editingKas = null;
  }

  void setFormFromKas(KasKeluar kas) {
    editingKas = kas;
    jumlahKasController.text = kas.jumlah.toString();
    tanggalKasController.text = kas.tanggal;
    caraKas.value = kas.cara;
    norekKasController.text = kas.norek ?? '';
    keteranganKasController.text = kas.keterangan ?? '';
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
      final success = await _kasKeluarService.insert(kasData);
      if (success) {
        WidgetSnackbar.success("Berhasil", "Kas masuk berhasil ditambahkan");
        resetForm();
        await fetchData();
        Get.offNamedUntil(AppRoutesConstants.kasKeluar, (route) => route.settings.name == AppRoutesConstants.home);
        Get.toNamed(AppRoutesConstants.kasKeluar);
      } else {
        WidgetSnackbar.danger("Gagal", "Data gagal ditambahkan");
      }
    } catch (e) {
      WidgetSnackbar.danger("Gagal", "Gagal menyimpan data");
    }
  }

  Future<void> updateKas(KasKeluar kas) async {
    try {
      final updatedKas = KasKeluar(
        id: kas.id,
        jumlah: double.parse(jumlahKasController.text),
        tanggal: tanggalKasController.text,
        cara: caraKas.value,
        norek: norekKasController.text.isNotEmpty ? norekKasController.text : null,
      );

      await _kasKeluarService.update(updatedKas);
      WidgetSnackbar.success("Sukses", "Kas masuk berhasil diubah");

      resetForm();
      editingKas = null;
      await fetchData();
      Get.offNamedUntil(AppRoutesConstants.kasKeluar, (route) => route.settings.name == AppRoutesConstants.home);
      Get.toNamed(AppRoutesConstants.kasKeluar);
    } catch (_) {
      WidgetSnackbar.danger("Gagal", "Gagal mengubah Kas Keluar");
    }
  }

  Future<void> deleteKas(int id) async {
    try {
      await _kasKeluarService.delete(id);
      await fetchData();
      WidgetSnackbar.success("Sukses", "Data berhasil dihapus");
    } catch (_) {
      WidgetSnackbar.danger("Gagal", "Gagal menghapus data");
    }
  }

  void goToAddPage() {
    resetForm();
    Get.toNamed(AppRoutesConstants.kasKeluarFormIsian);
  }

  void goToEditPage(KasKeluar kas) {
    setFormFromKas(kas);
    Get.toNamed(AppRoutesConstants.kasKeluarFormIsian, arguments: kas);
  }
}
