import 'dart:math';

import 'package:celebration_alert_app/alarm_list.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import "package:build_context/build_context.dart";
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:celebration_alert_app/model/alert.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AddAlarmPage extends StatefulWidget {
  AddAlarmPage({Key? key}) : super(key: key);

  @override
  _AddAlarmPageState createState() => _AddAlarmPageState();
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  @override
  void initState() {
    super.initState();
  }

  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text(
          'Add Celebration',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              context.read<AlertModel>().add(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Hello World')));
              Navigator.pop(context);
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) => CupertinoAlertDialog(
              //     title: Text('Alert'),
              //     content: Text('Celebration Date Saved'),
              //     actions: [
              //       CupertinoDialogAction(
              //         isDefaultAction: true,
              //         child: Text('Ok'),
              //         onPressed: () async {
              //           Navigator.of(context, rootNavigator: true).pop();
              //         },
              //       )
              //     ],
              //   ),
              // );
            },
          ),
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
              children: <Widget>[
                SfDateRangePicker(
                  initialSelectedDate:
                      alert.getCurrentFillingAlert['date'] ?? DateTime.now(),
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.single,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  yearCellStyle: DateRangePickerYearCellStyle(
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  headerStyle: DateRangePickerHeaderStyle(
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 8.0),
                ActionsRow(
                  callback: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) => AddRingTone(),
                    );
                  },
                  leadingText: "Ringtone",
                  trailingText:
                      "${alert.getCurrentFillingAlert.containsKey('ringtone') ? alert.getCurrentFillingAlert['ringtone']['name'] : ''}",
                ),
                ActionsRow(
                  callback: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) => AddRepeat(),
                    );
                  },
                  leadingText: "Repeat",
                  trailingText:
                      "${Repeat.values[alert.getCurrentFillingAlert['repeat']]}",
                ),
                ActionsRow(
                  callback: () {},
                  leadingText: "Vibrate when alarm sounds",
                  trailingWidgetIsCheckBox: true,
                  trailingWidget: FlutterSwitch(
                    width: 50.0,
                    height: 25,
                    valueFontSize: 12.0,
                    toggleSize: 16,
                    value: alert.getCurrentFillingAlert['vibrate'] ?? false,
                    showOnOff: true,
                    onToggle: (value) {
                      context
                          .read<AlertModel>()
                          .addCurrentFillingAlertData('vibrate', value);
                    },
                  ),
                ),
                ActionsRow(
                  callback: () {},
                  leadingText: "Delete after goes off",
                  trailingWidgetIsCheckBox: true,
                  trailingWidget: FlutterSwitch(
                    width: 50.0,
                    height: 25,
                    valueFontSize: 12.0,
                    toggleSize: 16,
                    value:
                        alert.getCurrentFillingAlert['deleteAfterOff'] ?? false,
                    showOnOff: true,
                    onToggle: (value) {
                      context
                          .read<AlertModel>()
                          .addCurrentFillingAlertData('deleteAfterOff', value);
                    },
                  ),
                ),
                ActionsRow(
                  callback: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) => AddAlarmLabelForm(),
                    );
                  },
                  leadingText: "Label",
                  trailingText:
                      "${alert.getCurrentFillingAlert['label'] ?? ''}",
                ),
                Text('$_selectedDate')
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    //
    if (args.value is PickerDateRange) {
      _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
          // ignore: lines_longer_than_80_chars
          ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
    } else if (args.value is DateTime) {
      _selectedDate = args.value.toString();
      context.read<AlertModel>().addCurrentFillingAlertData('date', args.value);
    } else if (args.value is List<DateTime>) {
      _dateCount = args.value.length.toString();
    } else {
      _rangeCount = args.value.length.toString();
    }
  }
}

class ActionsRow extends StatelessWidget {
  final VoidCallback? callback;
  final String? leadingText;
  final String? trailingText;
  final Widget? trailingWidget;
  final bool trailingWidgetIsCheckBox;
  ActionsRow({
    Key? key,
    this.callback,
    this.leadingText,
    this.trailingWidget,
    this.trailingText = "",
    this.trailingWidgetIsCheckBox = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.0),
        child: GestureDetector(
          onTap: callback,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$leadingText',
                style: context.bodyText2?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 16.0),
              trailingWidgetIsCheckBox
                  ? trailingWidget ?? Container()
                  : Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              '${trailingText}',
                              style: context.bodyText2?.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.white38,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_outlined,
                            color: Colors.white38,
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddAlarmLabelForm extends StatelessWidget {
  const AddAlarmLabelForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return AlertDialog(
      titleTextStyle: TextStyle(
        fontFamily: 'Montserrat',
        // fontSize: 18,
        color: Colors.black,
        letterSpacing: 1.0,
      ),
      titlePadding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      title: Text('Add Label'),
      content: SizedBox(
        height: 50,
        child: Form(
          key: _formKey,
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            onSaved: (value) => {
              if (value != null)
                context
                    .read<AlertModel>()
                    .addCurrentFillingAlertData('label', value)
            },
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Label...",
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            'CANCEL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
            }
            Navigator.of(context).pop(false);
          },
          child: Text(
            'OK',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class AddRepeat extends StatelessWidget {
  const AddRepeat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: TextStyle(
        fontFamily: 'Montserrat',
        color: Colors.black,
        letterSpacing: 1.0,
      ),
      titlePadding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
      title: Text('Select Repeat'),
      content: SizedBox(
        height: 145,
        child: Consumer<AlertModel>(
          builder: (context, alert, child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: Repeat.values
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      context
                          .read<AlertModel>()
                          .addCurrentFillingAlertData('repeat', e.index);
                    },
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${e.toString()}',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            alert.getCurrentFillingAlert['repeat'] == e.index
                                ? Icon(Icons.check,
                                    size: 14.0, color: Colors.blue)
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            'CANCEL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            'OK',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class AddRingTone extends StatelessWidget {
  const AddRingTone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: TextStyle(
        fontFamily: 'Montserrat',
        color: Colors.black,
        letterSpacing: 1.0,
      ),
      titlePadding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
      title: Text('Select RingTone'),
      content: SizedBox(
        height: 200,
        child: Consumer<AlertModel>(
          builder: (context, alert, child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: ringtoneList
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      context
                          .read<AlertModel>()
                          .addCurrentFillingAlertData('ringtone', e.toJson());
                    },
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${e.toJson()['name']}',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            alert.getCurrentFillingAlert['ringtone']['name'] ==
                                    e.toJson()['name']
                                ? Icon(Icons.check,
                                    size: 14.0, color: Colors.blue)
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            'CANCEL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            'OK',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
