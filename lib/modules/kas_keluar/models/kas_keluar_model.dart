import 'dart:convert';

class KasKeluar {
  final int? id;
  final String cara;
  final double jumlah;
  final String tanggal;
  final String? norek;
  final String? keterangan;

  KasKeluar({
    this.id,
    required this.cara,
    required this.jumlah,
    required this.tanggal,
    this.norek,
    this.keterangan,
  });

  Map<String, dynamic> toMap() {
    return {
      'kas_id': id,
      'kas_jenis': 'kas_keluar',
      'kas_cara': cara,
      'kas_jumlah': jumlah,
      'kas_tanggal': tanggal,
      'kas_norek': norek,
      'kas_keterangan': keterangan,
    };
  }

  factory KasKeluar.fromMap(Map<String, dynamic> map) {
    return KasKeluar(
      id: map['kas_id'],
      cara: map['kas_cara'],
      jumlah: (map['kas_jumlah'] as num).toDouble(),
      tanggal: map['kas_tanggal'],
      norek: map['kas_norek'],
      keterangan: map['kas_keterangan'],
    );
  }

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() => 'KasKeluar(${toJsonString()})';
}
