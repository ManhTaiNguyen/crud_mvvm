import 'dart:math';
import 'package:flutter/material.dart';

class SampleItem {
  final String id;
  final ValueNotifier<String> name;
  final ValueNotifier<double> price;

  SampleItem({String? id, required String name, double? price})
      : id = id ?? generateUuid(),
        name = ValueNotifier(name),
        price = ValueNotifier(price ?? 0.0);

  static String generateUuid() {
    return int.parse(
            '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(100000)}')
        .toRadixString(35)
        .substring(0, 9);
  }
}
