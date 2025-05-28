import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arta_krama/modules/kas_masuk/models/kas_masuk_model.dart';
import 'package:arta_krama/modules/kas_masuk/services/kas_masuk_service.dart';
import 'package:arta_krama/widgets/widget_snackbar.dart';
import 'package:arta_krama/routes/app_routes_constant.dart';

class KasMasukController extends GetxController {
  final KasMasukService _kasMasukService = KasMasukService();
  var kasMasukList = <KasMasuk>[].obs;

  // Observable untuk dropdown
  var jenisKas = 'kas_masuk'.obs;
  var caraKas = 'tunai'.obs;

  // TextEditingControllers
  final TextEditingController jumlahKasController = TextEditingController();
  final TextEditingController tanggalKasController = TextEditingController();
  final TextEditingController norekKasController = TextEditingController();

  KasMasuk? editingKas; // jika edit data

  @override
  void onInit() {
    super.onInit();
    fetchData();

    final kas = Get.arguments as KasMasuk?;
    if (kas != null) {
      editingKas = kas;
      // Model kamu tidak punya kasJenis property, jadi pakai default 'kas_masuk'
      // Jika suatu saat perlu, bisa disimpan di variabel lain
      jenisKas.value = 'kas_masuk'; 
      caraKas.value = kas.cara;
      jumlahKasController.text = kas.jumlah.toString();
      tanggalKasController.text = kas.tanggal;
      norekKasController.text = kas.norek;
    }
  }

  @override
  void onClose() {
    jumlahKasController.dispose();
    tanggalKasController.dispose();
    norekKasController.dispose();
    super.onClose();
  }

  Future<void> fetchData() async {
    try {
      final data = await _kasMasukService.getAll();
      kasMasukList.assignAll(data);
    } catch (e) {
      WidgetSnackbar.danger("Gagal", "Gagal memuat data kas masuk");
    }
  }

  Future<void> addKas(KasMasuk kas) async {
    try {
      await _kasMasukService.insert(kas);
      fetchData();
      WidgetSnackbar.success("Sukses", "Kas masuk berhasil ditambahkan");
      Get.back();
    } catch (e) {
      WidgetSnackbar.danger("Gagal", "Gagal menambah kas masuk");
    }
  }

  Future<void> updateKas(KasMasuk kas) async {
    try {
      await _kasMasukService.update(kas);
      fetchData();
      WidgetSnackbar.success("Sukses", "Kas masuk berhasil diubah");
      Get.back();
    } catch (e) {
      WidgetSnackbar.danger("Gagal", "Gagal mengubah kas masuk");
    }
  }

  Future<void> deleteKas(int id) async {
    try {
      await _kasMasukService.delete(id);
      fetchData();
      WidgetSnackbar.success("Sukses", "Data berhasil dihapus");
    } catch (e) {
      WidgetSnackbar.danger("Gagal", "Gagal menghapus data");
    }
  }

  void goToAddPage() {
    Get.toNamed(AppRoutesConstants.kasMasukForm); // pastikan route ini ada
  }

  void goToEditPage(KasMasuk kas) {
    Get.toNamed(AppRoutesConstants.kasMasukForm, arguments: kas);
  }

  void saveKas() {
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

    final kas = KasMasuk(
      id: editingKas?.id,
      cara: caraKas.value,
      jumlah: jumlah,
      tanggal: tanggalText,
      norek: norekText.isEmpty ? '-' : norekText,  // karena norek wajib di model
    );

    if (editingKas == null) {
      addKas(kas);
    } else {
      updateKas(kas);
    }
  }

}
