import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:arta_krama/core/utils/storage_service.dart'; // Import StorageService

class DatabaseHelper {
  final StorageService _storage = StorageService(); // Pakai StorageService
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  // Getter database untuk memastikan kita dapat mengakses DB yang aktif
  Future<Database> get database async {
    if (_database == null) {
      throw Exception(
        'Database belum diinisialisasi. Pastikan untuk membuka database terlebih dahulu.',
      );
    }
    return _database!;
  }

  // Membuka database dari path yang disimpan atau baru
  Future<Database> openDatabaseFromPath(String path) async {
    await closeDatabase(); // Tutup db sebelumnya jika ada
    _database = await openDatabase(path);
    return _database!;
  }

  // Init koneksi berdasarkan koneksi DB di path yang sudah disimpan
  Future<void> initDatabaseOffline() async {
    final savedPath = await _storage.read('offline_db_path');
    print(savedPath);
    if (savedPath != null) {
      try {
        await openDatabaseFromPath(savedPath);
        print("✅ [Database] Opened from saved path: $savedPath");

        // ✅ Cek apakah tabel 'transaksi' sudah ada
        final existingTables = await getAllTables();

        if (!existingTables.contains('user') ||
            !existingTables.contains('kas')) {
          print("ℹ️ [Database] Beberapa tabel belum ada. Membuat tabel...");
          await createTables();
        } else {
          print("✅ [Database] Semua tabel sudah tersedia, skip create.");
        }

        print("Tabel List: $existingTables");
      } catch (e) {
        print("❌ [Database] Failed to open saved DB: $e");
      }
    } else {
      print("ℹ️ [Database] No saved path found");
    }
  }

  // Untuk mengakses database saat sudah terbuka
  Database? get currentDatabase => _database;

  // Menutup database yang terbuka
  Future<void> closeDatabase() async {
    await _database?.close();
    _database = null;
  }

  // Fungsi untuk mengambil semua tabel yang ada di database
  Future<List<String>> getAllTables() async {
    final db = await database; // Pastikan database sudah terbuka
    final result = await db.rawQuery(
      'SELECT name FROM sqlite_master WHERE type="table"',
    );
    return result.map((table) => table['name'] as String).toList();
  }

  // Fungsi umum untuk mengambil data dari tabel tertentu secara dinamis
  Future<List<Map<String, dynamic>>> getDataFromTable(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  // Fungsi untuk menambah data ke tabel tertentu secara dinamis
  Future<int> insertData(String tableName, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(tableName, data);
  }

  // Fungsi untuk menghapus data berdasarkan ID dari tabel tertentu
  Future<int> deleteData(String tableName, String idColumn, int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<void> createTables() async {
    final db = await database;

    // Tabel User
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT,
        jenis_kelamin TEXT,
        no_induk TEXT,
        nama_lengkap TEXT,
        no_telp TEXT,
        alamat TEXT,
        email TEXT,
        jobdesk TEXT
      )
    ''');

    // Tabel Kas
    await db.execute('''
      CREATE TABLE IF NOT EXISTS kas (
        kas_id INTEGER PRIMARY KEY AUTOINCREMENT,
        kas_jenis TEXT,       -- 'kas_masuk' atau 'kas_keluar'
        kas_jumlah REAL,
        kas_tanggal TEXT,
        kas_cara TEXT,        -- 'tunai' atau 'card'
        kas_norek TEXT
      )
    ''');

    print("✅ [Database] Tabel user & kas berhasil dicek/dibuat.");
  }
}
