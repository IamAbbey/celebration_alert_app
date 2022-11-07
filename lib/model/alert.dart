import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class AlertModel extends ChangeNotifier {
  // final BuildContext context;

  // AlertModel({this.context});

  /// Internal, private state of the cart.
  List<Alert> _items = [];
  Map<String, dynamic> _currentFillingAlert = {
    'vibrate': true,
    'repeat': 0,
    'ringtone': ringtoneList[0].toJson(),
    'deleteAfterOff': false,
    'label': '',
    'date': DateTime.now()
  };

  // var box = Hive.box('celebrationApp');

  getItems() async {
    final box = await Hive.openBox<List<dynamic>>('celebrationApp');
    print(box.get('items', defaultValue: []));
    _items = box
        .get('items', defaultValue: [])!
        .map((e) => Alert.fromJson(e))
        .toList();

    notifyListeners();
  }

// box.put('name', 'David');

// var name = box.get('name');

// print('Name: $name');

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Alert> get items => UnmodifiableListView(_items);
  Map<String, dynamic> get getCurrentFillingAlert => _currentFillingAlert;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(context) async {
    final box = Hive.box<List<dynamic>>('celebrationApp');
    Random rnd = new Random();
    _currentFillingAlert['id'] = rnd.nextInt(1000000);
    Alert item = Alert.fromJson(_currentFillingAlert);
    _items.add(item);
    print(_items.map((e) => e.toJson()).toList());
    box.put('items', _items.map((e) => e.toJson()).toList());

    if (item.repeat == Repeat.Once) {
      await AndroidAlarmManager.oneShotAt(item.date, item.id, () {},
          rescheduleOnReboot: true, wakeup: true);
    } else if (item.repeat == Repeat.Every15mins) {
      await AndroidAlarmManager.periodic(Duration(minutes: 15), item.id, () {},
          rescheduleOnReboot: true, wakeup: true);
    } else if (item.repeat == Repeat.Every1hour) {
      await AndroidAlarmManager.periodic(Duration(hours: 1), item.id, () {},
          rescheduleOnReboot: true, wakeup: true);
    }

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void addCurrentFillingAlertData(String key, value) {
    _currentFillingAlert[key] = value;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  // Removes all items from the cart.
  void removeAll(String id) {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  // Removes all items from the cart.
  void removeCurrentFillingAlert() {
    _currentFillingAlert = {
      'vibrate': true,
      'repeat': 0,
      'ringtone': ringtoneList[0].toJson(),
      'deleteAfterOff': false,
      'label': '',
      'date': DateTime.now()
    };
  }
}

enum Repeat { Once, Every15mins, Every1hour }

List<Ringtone> ringtoneList = [
  Ringtone(name: 'Ping Pong', ringtoneURL: ''),
  Ringtone(name: 'Buzz', ringtoneURL: ''),
  Ringtone(name: 'Fang', ringtoneURL: ''),
  Ringtone(name: 'Blizzer', ringtoneURL: ''),
];

const _chars = '0123456789';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class Alert {
  final int id;
  final DateTime date;
  final Ringtone ringtone;
  final Repeat repeat;
  final bool vibrate;
  final bool deleteAfterOff;
  final bool isActive;
  final String label;

  Alert({
    required this.id,
    required this.date,
    required this.ringtone,
    required this.label,
    this.vibrate = false,
    this.isActive = true,
    this.deleteAfterOff = false,
    this.repeat = Repeat.Once,
  });

  factory Alert.fromJson(dynamic json) => Alert(
        id: json["id"] as int,
        date: json["date"] as DateTime,
        ringtone: Ringtone.fromJson(json["ringtone"]),
        repeat: Repeat.values[json["repeat"]],
        vibrate: json["vibrate"] as bool,
        deleteAfterOff: json["deleteAfterOff"] as bool,
        isActive: json["isActive"] ?? true,
        label: json["label"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "ringtone": ringtone.toJson(),
        "repeat": repeat.index,
        "vibrate": vibrate,
        "deleteAfterOff": deleteAfterOff,
        "label": label,
        "isActive": isActive,
      };
}

class Ringtone {
  final String name;
  final String ringtoneURL;

  Ringtone({
    required this.name,
    required this.ringtoneURL,
  });

  factory Ringtone.fromJson(dynamic json) => Ringtone(
        name: json["name"] as String,
        ringtoneURL: json["ringtoneURL"] as String,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "ringtoneURL": ringtoneURL,
      };
}
