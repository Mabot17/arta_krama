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

  Future<int> insert(KasMasuk kas) async {
    final db = await _dbHelper.database;
    return await db.insert('kas', kas.toMap());
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
