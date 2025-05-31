import 'package:arta_krama/core/utils/database_helper.dart';
import 'package:arta_krama/modules/kas_keluar/models/kas_keluar_model.dart';

class KasKeluarService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<KasKeluar>> getAll() async {
    final db = await _dbHelper.database;
    print("DATABASE PATH: ${db.path}");
    final result = await db.query(
      'kas',
      where: 'kas_jenis = ?',
      whereArgs: ['kas_keluar'],
      orderBy: 'kas_tanggal DESC',
    );
    return result.map((e) => KasKeluar.fromMap(e)).toList();
  }

  Future<bool> insert(Map<String, dynamic> kas) async {
    try {
      final db = await _dbHelper.database;

      await db.insert('kas', kas);
      return true;
    } catch (e) {
      print("❌ Error saat insert Kas Keluar: $e");
      return false;
    }
  }

  Future<bool> update(KasKeluar kas) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'kas',
        kas.toMap(),
        where: 'kas_id = ?',
        whereArgs: [kas.id],
      );
      return true;
    } catch (e) {
      print("❌ Error saat insert Kas Keluar: $e");
      return false;
    }
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('kas', where: 'kas_id = ?', whereArgs: [id]);
  }
}
