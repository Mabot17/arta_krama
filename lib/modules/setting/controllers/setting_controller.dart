import 'dart:io';
import 'package:arta_krama/core/utils/storage_service.dart'; // StorageService
import 'package:arta_krama/core/utils/database_helper.dart'; // Import StorageService
import 'package:arta_krama/widgets/widget_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingController {
  final StorageService _storage = StorageService();

  Future<void> backupDatabaseToDownload() async {
    // Cek izin penyimpanan
    if (!await Permission.storage.request().isGranted) {
      WidgetSnackbar.danger("Gagal", "Izin akses penyimpanan ditolak.");
      return;
    }

    // Ambil path file database
    final dbPath = await _storage.read('offline_db_path') ?? '';
    if (dbPath.isEmpty) {
      WidgetSnackbar.danger("Gagal", "Path database tidak ditemukan!");
      return;
    }

    try {
      // Ambil folder Download via path umum
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final filename = dbPath.split('/').last;
      final destinationPath = '${downloadsDir.path}/$filename';

      final sourceFile = File(dbPath);
      await sourceFile.copy(destinationPath);

      WidgetSnackbar.success("Sukses", "Data berhasil di-backup ke folder Download.");
    } catch (e) {
      print("Backup error: $e");
      WidgetSnackbar.danger("Gagal", "Gagal memindahkan file ke folder Download.");
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
