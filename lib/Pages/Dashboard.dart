import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String,List> dashlist ={};
  List dashlistkey =[];
  Map<String,double> dataMap ={'Students in': 0, 'Students out':0};
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  @override
  void initState() {
    super.initState();
    get_current_data();
    listdata();

    ref.child('Data/Status').onValue.listen((event) {
      setState(() {
        dataMap = {'Students in': double.parse('${event.snapshot.child('in').value}'), 'Students out':double.parse('${event.snapshot.child('out').value}')};

      });
    });

  }


  void listdata() async {
    DatabaseEvent dataSnapshot = await FirebaseDatabase.instance.ref('Guests').orderByChild('Current Status').equalTo('in').once();
    final values = dataSnapshot.snapshot.value;
    print(values);

    setState(() {
      if (values != null) {
        (values as Map).forEach((key, value) {
          if (dashlist.containsKey(value['Designation'])) {
            if (value['Name'] != null && value['PhoneNo'] != null) {
              dashlist[value['Designation']]?.add({'Name': value['Name'], 'PhoneNo': value['PhoneNo']});
            }
          } else {
            if (value['Name'] != null && value['PhoneNo'] != null) {
              dashlist[value['Designation']] = [{'Name': value['Name'], 'PhoneNo': value['PhoneNo']}];
            }
          }
          print('---------------ddddddddddddddddddddddd$dashlist');
        });
        dashlistkey = dashlist.keys.toList();
        print('------------------------kkkkkkkkkkkkkkkkkkkkkkk$dashlistkey');
      } else {
        dashlist['All students are out'] = [{'Name': 'null', 'PhoneNo': 'null'}];
      }
    });
  }

  @override
  void get_current_data() async {
    final snapshot = await ref.child('Data/Status').get();
    if (snapshot.exists) {
      setState(() {
        final inValue = snapshot.child('in').value;
        final outValue = snapshot.child('out').value;
        dataMap['Students in'] = double.parse('$inValue');
        dataMap['Students out'] = double.parse('$outValue');
        print('-----------------------------------------------${snapshot.child('in')}');

      });
    }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(padding: const EdgeInsets.all(16.0),child: chart(),),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: dashlistkey.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(padding: const EdgeInsets.all(2),child: ExpansionTile(title: Text(' ${dashlistkey[index]}    in:${dashlist[dashlistkey[index]]?.length  ?? 0}'),children: [
                  SizedBox(
                    height: dashlist[dashlistkey[index]] != null
                        ? dashlist[dashlistkey[index]]!.length * 50
                        : 0, // Set a fixed height for the inner ListView
                    child: ListView.builder(
                        itemCount: dashlist[dashlistkey[index]]?.length ?? 0,
                        itemBuilder: (BuildContext context,int index1){
                          return Padding(padding: const EdgeInsets.all(0.5),child: Row(children: [Text('${index1+1}. ${dashlist[dashlistkey[index]]?[index1]['Name']}'),TextButton(onPressed: ()async{launch('tel://+91${dashlist[dashlistkey[index]]?[index1]['PhoneNo']}');}, child: Text('${dashlist[dashlistkey[index]]?[index1]['PhoneNo']}'))]));
                        }
                    ),
                  )
                ],));
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget chart()=>
      PieChart(dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: const [Colors.red,Colors.green],
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 30,
        centerText: "Status",
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape:BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 0,
        ),
      );
}
