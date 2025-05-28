import 'package:arta_krama/core/utils/database_helper.dart';
import 'package:arta_krama/modules/kas_masuk/models/kas_masuk_model.dart';

class KasMasukService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<KasMasuk>> getAll() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'kas',
      where: 'kas_jenis = ?',
      whereArgs: ['kas_masuk'],
      orderBy: 'kas_tanggal DESC',
    );
    return result.map((e) => KasMasuk.fromMap(e)).toList();
  }

  Future<bool> insert(Map<String, dynamic> kas) async {
    try {
      final db = await _dbHelper.database;

      await db.insert('kas', kas);
      return true;
    } catch (e) {
      print("❌ Error saat insert kas masuk: $e");
      return false;
    }
  }

  Future<int> update(KasMasuk kas) async {
    final db = await _dbHelper.database;
    return await db.update(
      'kas',
      kas.toMap(),
      where: 'kas_id = ?',
      whereArgs: [kas.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('kas', where: 'kas_id = ?', whereArgs: [id]);
  }
}
