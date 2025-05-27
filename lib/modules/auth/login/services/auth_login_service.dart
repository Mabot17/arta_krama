import 'package:arta_krama/core/utils/storage_service.dart';
import 'package:arta_krama/core/utils/database_helper.dart';

class AuthLoginService {
  final StorageService _storage = StorageService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<bool> login(String username, String password) async {
    try {
      final db = await _dbHelper.database;

      final result = await db.query(
        'user',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      if (result.isNotEmpty) {
        final user = result.first;

        // Simpan data user (opsional)
        _storage.write(
          'access_token',
          'dummy_token',
        ); // bisa diganti dengan hash token
        _storage.write('user_data', user); // Menyimpan info user

        return true;
      }

      return false;
    } catch (e) {
      print("❌ Error saat login: $e");
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      final db = await _dbHelper.database;

      // Pastikan username belum dipakai
      final existing = await db.query(
        'user',
        where: 'username = ?',
        whereArgs: [userData['username']],
      );

      if (existing.isNotEmpty) return false;

      await db.insert('user', userData);
      return true;
    } catch (e) {
      print("❌ Error saat register: $e");
      return false;
    }
  }

  void logout() {
    _storage.clear();
  }

  bool isLoggedIn() {
    return _storage.has('access_token');
  }
}
