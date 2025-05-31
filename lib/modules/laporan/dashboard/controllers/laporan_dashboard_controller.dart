import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:arta_krama/modules/laporan/arus_kas/services/laporan_arus_kas_service.dart';
import 'package:arta_krama/modules/laporan/arus_kas/models/laporan_arus_kas_model.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController {
  final ArusKasService _service = ArusKasService();

  final kasMasuk = <ArusKas>[].obs;
  final kasKeluar = <ArusKas>[].obs;

  List<PieChartSectionData> pieData = [];
  List<BarChartGroupData> barData = [];
  List<FlSpot> lineData = [];
  List<String> labels = [];

  double maxYBar = 0;
  double maxYLine = 0;

  Future<void> loadData(DateTime tglAwal, DateTime tglAkhir) async {
    kasMasuk.value = await _service.getKasMasuk(tglAwal, tglAkhir);
    kasKeluar.value = await _service.getKasKeluar(tglAwal, tglAkhir);

    generatePieData();
    generateBarAndLineData();
  }

  void generatePieData() {
    final totalMasuk = kasMasuk.fold<double>(0, (sum, item) => sum + item.jumlah);
    final totalKeluar = kasKeluar.fold<double>(0, (sum, item) => sum + item.jumlah);

    pieData = [
      PieChartSectionData(
        value: totalMasuk,
        title: 'Masuk',
        color: Colors.green,
        titleStyle: TextStyle(color: Colors.white, fontSize: 12),
      ),
      PieChartSectionData(
        value: totalKeluar,
        title: 'Keluar',
        color: Colors.red,
        titleStyle: TextStyle(color: Colors.white, fontSize: 12),
      ),
    ];
  }

  void generateBarAndLineData() {
    Map<String, double> masukMap = {};
    Map<String, double> keluarMap = {};

    for (var kas in kasMasuk) {
      masukMap[kas.tanggal] = (masukMap[kas.tanggal] ?? 0) + kas.jumlah;
    }

    for (var kas in kasKeluar) {
      keluarMap[kas.tanggal] = (keluarMap[kas.tanggal] ?? 0) + kas.jumlah;
    }

    final allDates = {...masukMap.keys, ...keluarMap.keys}.toList();
    allDates.sort();

    labels = allDates;
    barData = [];
    lineData = [];
    maxYBar = 0;
    maxYLine = 0;

    for (int i = 0; i < labels.length; i++) {
      final tanggal = labels[i];
      final masuk = masukMap[tanggal] ?? 0;
      final keluar = keluarMap[tanggal] ?? 0;

      barData.add(
        BarChartGroupData(x: i, barRods: [
          BarChartRodData(toY: masuk, color: Colors.green, width: 6),
          BarChartRodData(toY: keluar, color: Colors.red, width: 6),
        ]),
      );

      final net = masuk - keluar;
      lineData.add(FlSpot(i.toDouble(), net));

      if (masuk > maxYBar) maxYBar = masuk;
      if (keluar > maxYBar) maxYBar = keluar;

      if (net.abs() > maxYLine) maxYLine = net.abs();
    }

    maxYBar *= 1.2;
    maxYLine *= 1.2;
  }
}
