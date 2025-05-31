import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arta_krama/modules/laporan/dashboard/controllers/laporan_dashboard_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:arta_krama/widgets/widget_appbar.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardController controller = Get.find<DashboardController>();
  DateTime tglAwal = DateTime.now().subtract(Duration(days: 30));
  DateTime tglAkhir = DateTime.now();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() => isLoading = true);
    await controller.loadData(tglAwal, tglAkhir);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const WidgetAppBar(title: "Dashboard"),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Periode: ${DateFormat('dd/MM/yyyy').format(tglAwal)} - ${DateFormat('dd/MM/yyyy').format(tglAkhir)}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        initialDateRange: DateTimeRange(start: tglAwal, end: tglAkhir),
                      );
                      if (picked != null) {
                        setState(() {
                          tglAwal = picked.start;
                          tglAkhir = picked.end;
                        });
                        loadData();
                      }
                    },
                  ),
                ],
              ),
            ),
            if (isLoading)
              Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.black,
                      tabs: const [
                        Tab(text: 'Garis'),
                        Tab(text: 'Pie'),
                        Tab(text: 'Batang'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // GARIS (Line Chart)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: AspectRatio(
                              aspectRatio: 1.6,
                              child: LineChart(
                                LineChartData(
                                  minY: 0,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: controller.lineData,
                                      isCurved: true,
                                      barWidth: 2,
                                      color: Colors.blue,
                                      belowBarData: BarAreaData(show: false),
                                      dotData: FlDotData(show: true),
                                    ),
                                  ],
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          final index = value.toInt();
                                          if (index >= 0 && index < controller.labels.length) {
                                            final date = controller.labels[index];
                                            final dt = DateTime.tryParse(date);
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Text(
                                                dt != null ? DateFormat('d/M').format(dt) : '',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            );
                                          }
                                          return Text('');
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: controller.maxYLine / 5,
                                        getTitlesWidget: (value, _) => Text(
                                          value.toInt().toString(),
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  gridData: FlGridData(show: true),
                                  borderData: FlBorderData(show: true),
                                ),
                              ),
                            ),
                          ),

                          // PIE CHART
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: AspectRatio(
                              aspectRatio: 1.2,
                              child: PieChart(
                                PieChartData(
                                  sections: controller.pieData,
                                  sectionsSpace: 4,
                                  centerSpaceRadius: 40,
                                ),
                              ),
                            ),
                          ),

                          // BATANG (Bar Chart)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: AspectRatio(
                              aspectRatio: 1.6,
                              child: BarChart(
                                BarChartData(
                                  maxY: controller.maxYBar,
                                  barGroups: controller.barData,
                                  gridData: FlGridData(show: true),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final index = value.toInt();
                                          if (index >= 0 && index < controller.labels.length) {
                                            final date = controller.labels[index];
                                            final dt = DateTime.tryParse(date);
                                            return Transform.rotate(
                                              angle: -0.5,
                                              child: Text(
                                                dt != null ? DateFormat('d/M').format(dt) : '',
                                                style: TextStyle(fontSize: 9),
                                              ),
                                            );
                                          }
                                          return Text('');
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: controller.maxYBar / 5,
                                        getTitlesWidget: (value, _) => Text(
                                          value.toInt().toString(),
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: true),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
