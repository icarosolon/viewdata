import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';

/// Data class to visualize.
class _CostsData {
  final String category;
  final int cost;

  const _CostsData(this.category, this.cost);
}

class PieChartExample extends StatefulWidget {
  const PieChartExample({Key key}) : super(key: key);

  @override
  _PieChartExampleState createState() => _PieChartExampleState();
}

class _PieChartExampleState extends State<PieChartExample> {
  // Chart configs.
  bool _animate = true;
  double _arcRatio = 0.8;
  charts.ArcLabelPosition _arcLabelPosition = charts.ArcLabelPosition.auto;
  charts.BehaviorPosition _titlePosition = charts.BehaviorPosition.bottom;
  charts.BehaviorPosition _legendPosition = charts.BehaviorPosition.bottom;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  List<_CostsData> _data;

  @override
  void initState() {
    super.initState();
    refreshExams();
  }

  Future refreshExams() async {
    //refreshKey.currentState?.show(atTop: false);
    //await Future.delayed(Duration(seconds: 2));
    setState(() {
      this.getExams();
    });
  }

  Future getExams() async {
    // Data to render.
    _data = null;
    _data = [
      _CostsData('Janeiro', 1000),
      _CostsData('Fevereiro', 500),
      _CostsData('Março', 200),
      _CostsData('Abril', 100),
      _CostsData('Maio', 1500),
    ];
    return _data;
  }

  @override
  Widget build(BuildContext context) {
    final _colorPalettes =
        charts.MaterialPalette.getOrderedPalettes(this._data.length);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 70,
            ),
          ),
          Title(
            color: Colors.green,
            child: Text(
              "CDU - Centro de Diagnóstico Unimed",
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 400,
            padding: new EdgeInsets.only(
              bottom: 50,
            ),
            child: charts.PieChart(
              // Pie chart can only render one series.
              /*seriesList=*/ [
                charts.Series<_CostsData, String>(
                  id: 'Sales-1',
                  colorFn: (_, idx) => _colorPalettes[idx].shadeDefault,
                  domainFn: (_CostsData sales, _) => sales.category,
                  measureFn: (_CostsData sales, _) => sales.cost,
                  data: this._data,
                  // Set a label accessor to control the text of the arc label.
                  labelAccessorFn: (_CostsData row, _) =>
                      '${row.category}: ${row.cost}',
                ),
              ],
              animate: this._animate,
              defaultRenderer: new charts.ArcRendererConfig(
                arcRatio: this._arcRatio,
                arcRendererDecorators: [
                  charts.ArcLabelDecorator(
                      labelPosition: this._arcLabelPosition)
                ],
              ),

              behaviors: [
                // Add title.
                charts.ChartTitle(
                  '\n\nExames sem Accession Number',
                  behaviorPosition: this._titlePosition,
                ),
                // Add legend. ("Datum" means the "X-axis" of each data point.)
                charts.DatumLegend(
                  position: this._legendPosition,
                  desiredMaxRows: 20,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: refreshExams,
        elevation: 20,
        label: Text('Atualizar'),
        icon: Icon(Icons.refresh),
        backgroundColor: Colors.green,
      ),
    );
  }
}
