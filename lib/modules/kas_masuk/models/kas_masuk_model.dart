import 'dart:convert';

class KasMasuk {
  final int? id;
  final String cara;
  final double jumlah;
  final String tanggal;
  final String? norek;

  KasMasuk({
    this.id,
    required this.cara,
    required this.jumlah,
    required this.tanggal,
    this.norek,
  });

  Map<String, dynamic> toMap() {
    return {
      'kas_id': id,
      'kas_jenis': 'kas_masuk',
      'kas_cara': cara,
      'kas_jumlah': jumlah,
      'kas_tanggal': tanggal,
      'kas_norek': norek,
    };
  }

  factory KasMasuk.fromMap(Map<String, dynamic> map) {
    return KasMasuk(
      id: map['kas_id'],
      cara: map['kas_cara'],
      jumlah: (map['kas_jumlah'] as num).toDouble(),
      tanggal: map['kas_tanggal'],
      norek: map['kas_norek'],
    );
  }

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() => 'KasMasuk(${toJsonString()})';
}
