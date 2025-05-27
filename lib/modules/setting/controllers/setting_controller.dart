import 'dart:io';
import 'package:arta_krama/core/utils/storage_service.dart'; // StorageService
import 'package:arta_krama/core/utils/database_helper.dart'; // Import StorageService
import 'package:arta_krama/widgets/widget_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class SettingController {
  final StorageService _storage = StorageService();

  Future<void> backupDatabaseToDownload() async {
    // Mendapatkan path database yang disimpan di aplikasi
    final dbPath = await _storage.read('offline_db_path') ?? '';
    if (dbPath.isEmpty) {
      WidgetSnackbar.danger("Gagal", "Path database tidak ditemukan!");
      return;
    }

    // Mendapatkan path folder Download pada penyimpanan eksternal
    final downloadDir = Directory('/storage/emulated/0/Download');
    if (!await downloadDir.exists()) {
      await downloadDir.create(
        recursive: true,
      ); // Membuat folder Download jika belum ada
    }

    final filename = dbPath.split('/').last;
    final destinationPath = '${downloadDir.path}/$filename';

    // Menyalin file ke folder Download
    final sourceFile = File(dbPath);
    // final destinationFile = File(destinationPath);

    try {
      await sourceFile.copy(destinationPath);
      WidgetSnackbar.success(
        "Sukses",
        "Data berhasil di backup, silahkan cek folder download",
      );
    } catch (e) {
      WidgetSnackbar.danger(
        "Gagal",
        "Gagal memindahkan file ke folder Download.",
      );
    }
  }

  Future<bool> restoreDatabaseFromLocal() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);
      final dbHelper = DatabaseHelper();

      if (result == null || result.files.single.path == null) {
        WidgetSnackbar.danger("Dibatalkan", "Pemilihan file dibatalkan.");
        return false;
      }

      final selectedFile = File(result.files.single.path!);
      final fileName = selectedFile.path.split('/').last;

      if (!fileName.endsWith('.db')) {
        WidgetSnackbar.danger("Gagal", "File yang dipilih bukan file .db.");
        return false;
      }

      final dir = await getApplicationDocumentsDirectory();
      final destinationPath = "${dir.path}/${fileName}";

      await selectedFile.copy(destinationPath);

      await _storage.write('offline_db_path', destinationPath);
      WidgetSnackbar.success("Sukses", "Database berhasil di-restore.");
      await dbHelper.initDatabaseOffline();

      print("✅ File DB disimpan di: $destinationPath");
      return true;
    } catch (e) {
      WidgetSnackbar.danger("Error", "Terjadi kesalahan saat restore.");
      print("❌ Error restore: $e");
      return false;
    }
  }
}
