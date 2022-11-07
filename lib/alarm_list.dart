import 'package:celebration_alert_app/add_alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import "package:build_context/build_context.dart";
import 'package:intl/intl.dart';
import 'package:locally/locally.dart';
import 'package:celebration_alert_app/model/alert.dart';
import 'package:provider/provider.dart';

class AlarmListPage extends StatefulWidget {
  AlarmListPage({Key? key}) : super(key: key);

  @override
  _AlarmListPageState createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    context.read<AlertModel>().getItems();
  }

  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text(
          'Celebration',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.more_vert_rounded),
        ],
        backgroundColor: Colors.black54,
        elevation: 0,
        // toolbarHeight: kToolbarHeight * 0.5,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Consumer<AlertModel>(
            builder: (context, alert, child) => Column(
                children: alert.items.map((e) => NewWidget(alert: e)).toList()),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white12,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAlarmPage()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class NewWidget extends StatefulWidget {
  final Alert alert;
  NewWidget({Key? key, required this.alert}) : super(key: key);

  @override
  _NewWidgetState createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  bool status = true;
  @override
  Widget build(BuildContext context) {
    Alert alert = widget.alert;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    // text: '${alert.label.isNotEmpty ? alert.label : 'No label'}',
                    // text: '${DateFormat('hh:mm').format(alert.date)}',
                    text: '${DateFormat('dd/MM/yyyy').format(alert.date)}',
                    style: context.headline6,
                    children: <TextSpan>[
                      // TextSpan(
                      //   text: 'am',
                      //   style: context.bodyText2?.copyWith(
                      //     fontWeight: FontWeight.normal,
                      //     fontSize: 12,
                      //   ),
                      // ),
                      TextSpan(
                        // text:
                        //     ' | ${alert.label.isNotEmpty ? alert.label : 'No label'}',
                        text:
                            ' | Alarm in ${daysBetween(alert.date, DateTime.now())}',
                        style: context.bodyText2?.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  // "${DateFormat('dd/MM/yyyy').format(alert.date)} | Alarm in ${daysBetween(alert.date, DateTime.now())} hours",
                  "${alert.label.isNotEmpty ? alert.label : 'No label'}",
                  style: context.bodyText2?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 16.0),
          FlutterSwitch(
            width: 50.0,
            height: 25,
            valueFontSize: 12.0,
            toggleSize: 16,
            value: status,
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                status = val;
              });
            },
          ),
        ],
      ),
    );
  }

  String daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inHours == 0
        ? '${to.difference(from).inMinutes} Minutes'
        : '${to.difference(from).inHours} Hours';
  }
}
