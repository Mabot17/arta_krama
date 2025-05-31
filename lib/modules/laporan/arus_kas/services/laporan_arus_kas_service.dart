import 'package:arta_krama/core/utils/database_helper.dart';
import 'package:arta_krama/modules/laporan/arus_kas/models/laporan_arus_kas_model.dart';

class ArusKasService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<ArusKas>> getKasMasuk(DateTime start, DateTime end) async {
    final db = await _dbHelper.database;
    final startStr = _formatDate(start);
    final endStr = _formatDate(end);
    final result = await db.query(
      'kas',
      where: 'kas_jenis = ? AND kas_tanggal BETWEEN ? AND ?',
      whereArgs: ['kas_masuk', startStr, endStr],
      orderBy: 'kas_tanggal DESC',
    );
    return result.map((e) => ArusKas.fromMap(e)).toList();
  }

  Future<List<ArusKas>> getKasKeluar(DateTime start, DateTime end) async {
    final db = await _dbHelper.database;
    final startStr = _formatDate(start);
    final endStr = _formatDate(end);
    final result = await db.query(
      'kas',
      where: 'kas_jenis = ? AND kas_tanggal BETWEEN ? AND ?',
      whereArgs: ['kas_keluar', startStr, endStr],
      orderBy: 'kas_tanggal DESC',
    );
    return result.map((e) => ArusKas.fromMap(e)).toList();
  }

  String _formatDate(DateTime date) {
    // Format: yyyy-MM-dd
    return date.toIso8601String().split('T').first;
  }
}
