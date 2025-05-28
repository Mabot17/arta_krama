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
      print("Data fetched: ${data.length} items");
      kasMasukList.assignAll(data);
    } catch (e) {
      WidgetSnackbar.warning("Peringatan", "Data kas masuk tidak ditemukan");
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

  Future<void> saveKas() async {
    try {
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

      var kasData = {
        'kas_jenis': jenisKas.value,
        'kas_cara': caraKas.value,
        'kas_jumlah': jumlah,
        'kas_tanggal': tanggalText,
        'kas_norek': norekText.isNotEmpty ? norekText : null,
      };

      bool success = await _kasMasukService.insert(kasData);
      if (success) {
        WidgetSnackbar.success("Berhasil", "Registrasi Menambahkan kas masuk berhasil");
        Get.offAllNamed(AppRoutesConstants.kasMasuk);
      } else {
        WidgetSnackbar.danger("Gagal", "Data Gagal ditambahkan");
      }

    } catch (e) {
      print("Error saat menyimpan kas: $e");
      WidgetSnackbar.danger("Gagal", "Gagal Insert data");
    }
  }

}
