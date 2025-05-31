import 'dart:convert';

class KasMasuk {
  final int? id;
  final String cara;
  final double jumlah;
  final String tanggal;
  final String? norek;
  final String? keterangan;

  KasMasuk({
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
      'kas_jenis': 'kas_masuk',
      'kas_cara': cara,
      'kas_jumlah': jumlah,
      'kas_tanggal': tanggal,
      'kas_norek': norek,
      'kas_keterangan': keterangan,
    };
  }

  factory KasMasuk.fromMap(Map<String, dynamic> map) {
    return KasMasuk(
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
  String toString() => 'KasMasuk(${toJsonString()})';
}
