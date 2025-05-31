import 'package:get/get.dart';
import 'package:arta_krama/modules/laporan/arus_kas/models/laporan_arus_kas_model.dart';
import 'package:arta_krama/modules/laporan/arus_kas/services/laporan_arus_kas_service.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:arta_krama/widgets/widget_snackbar.dart';
import 'package:flutter/material.dart';

class ArusKasController extends GetxController {
  final ArusKasService _service = ArusKasService();

  var isLoading = false.obs;
  var kasMasukList = <ArusKas>[].obs;
  var kasKeluarList = <ArusKas>[].obs;

  var startDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  var endDate = DateTime.now().obs;

  RxList<ArusKasExtended> combinedList = <ArusKasExtended>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    everAll([startDate, endDate], (_) => fetchData());
  }

  void setStartDate(DateTime date) => startDate.value = date;
  void setEndDate(DateTime date) => endDate.value = date;

  Future<void> fetchData() async {
    isLoading.value = true;
    final masuk = await _service.getKasMasuk(startDate.value, endDate.value);
    final keluar = await _service.getKasKeluar(startDate.value, endDate.value);

    kasMasukList.value = masuk;
    kasKeluarList.value = keluar;

    _combineLists();
    isLoading.value = false;
  }

  void _combineLists() {
    final masukExtended = kasMasukList.map((e) => ArusKasExtended.fromArusKas(e, true)).toList();
    final keluarExtended = kasKeluarList.map((e) => ArusKasExtended.fromArusKas(e, false)).toList();

    final all = [...masukExtended, ...keluarExtended];
    all.sort((a, b) => a.dateTime.compareTo(b.dateTime)); // Urutan ASCENDING
    combinedList.value = all;
  }

  double getSaldoAkhir() {
    return combinedList.fold(0, (total, item) {
      return total + (item.isMasuk ? item.jumlah : -item.jumlah);
    });
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;

    if (status.isDenied) {
      // Tampilkan dialog custom sebelum request izin
      bool? result = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Izin Penyimpanan'),
          content: Text('Aplikasi butuh izin penyimpanan untuk menyimpan file export. Izinkan sekarang?'),
          actions: [
            TextButton(onPressed: () => Get.back(result: false), child: Text('Tolak')),
            ElevatedButton(onPressed: () => Get.back(result: true), child: Text('Izinkan')),
          ],
        ),
        barrierDismissible: false,
      );

      if (result == true) {
        status = await Permission.storage.request();
        if (status.isGranted) return true;

        // Kalau user tolak izin, tawarkan ke pengaturan
        await Get.dialog(
          AlertDialog(
            title: Text('Izin Ditolak'),
            content: Text('Izin penyimpanan diperlukan untuk export. Buka pengaturan aplikasi untuk mengizinkan?'),
            actions: [
              TextButton(onPressed: () => Get.back(), child: Text('Tidak')),
              ElevatedButton(
                onPressed: () {
                  openAppSettings();
                  Get.back();
                },
                child: Text('Buka Pengaturan'),
              ),
            ],
          ),
        );
        return false;
      } else {
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      // Langsung tawarkan buka pengaturan kalau izin permanen ditolak
      await Get.dialog(
        AlertDialog(
          title: Text('Izin Permanen Ditolak'),
          content: Text('Silakan buka pengaturan aplikasi untuk mengizinkan izin penyimpanan.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                openAppSettings();
                Get.back();
              },
              child: Text('Buka Pengaturan'),
            ),
          ],
        ),
      );
      return false;
    } else if (status.isGranted) {
      return true;
    }

    // Default fallback request izin
    status = await Permission.storage.request();
    return status.isGranted;
  }


  Future<void> exportToCsv() async {
    final granted = await requestStoragePermission();
    if (!granted) {
      WidgetSnackbar.danger("Izin Ditolak", "Izin penyimpanan dibutuhkan untuk export CSV");
      return;
    }

    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      WidgetSnackbar.danger("Error", "Tidak dapat mengakses storage");
      return;
    }

    final path = directory.path;
    final fileName = 'Laporan_Arus_Kas_${DateTime.now().millisecondsSinceEpoch}.csv';

    final file = File('$path/$fileName');

    final header = 'Tanggal,Jumlah,Tipe,Keterangan,No. Rekening,Cara\n';

    final buffer = StringBuffer();
    buffer.write(header);

    final formatRupiah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    if (combinedList.isEmpty) {
      WidgetSnackbar.warning("Peringatan", "Data kas masuk tidak ditemukan");
      return;
    }

    for (var item in combinedList) {
      final row = [
        item.tanggal,
        formatRupiah.format(item.jumlah).replaceAll(',', ''), // hilangkan koma supaya csv aman
        item.isMasuk ? 'Masuk' : 'Keluar',
        (item.keterangan ?? '').replaceAll(',', ' '),
        (item.norek ?? '').replaceAll(',', ' '),
        item.cara.replaceAll(',', ' '),
      ].join(',');

      buffer.writeln(row);
    }

    await file.writeAsString(buffer.toString());

    WidgetSnackbar.success("Sukses", "Export CSV berhasil: $fileName");
  }

}

class ArusKasExtended extends ArusKas {
  final bool isMasuk;
  final DateTime dateTime;

  ArusKasExtended({
    int? id,
    required String cara,
    required double jumlah,
    required String tanggal,
    String? norek,
    String? keterangan,
    required this.isMasuk,
    required this.dateTime,
  }) : super(
          id: id,
          cara: cara,
          jumlah: jumlah,
          tanggal: tanggal,
          norek: norek,
          keterangan: keterangan,
        );

  factory ArusKasExtended.fromArusKas(ArusKas arusKas, bool isMasuk) {
    final dt = DateTime.tryParse(arusKas.tanggal) ?? DateTime.now();
    return ArusKasExtended(
      id: arusKas.id,
      cara: arusKas.cara,
      jumlah: arusKas.jumlah,
      tanggal: arusKas.tanggal,
      norek: arusKas.norek,
      keterangan: arusKas.keterangan,
      isMasuk: isMasuk,
      dateTime: dt,
    );
  }
}
