import 'package:flutter/material.dart';
import 'models.dart';

class SampleItemViewModel extends ChangeNotifier {
  static final SampleItemViewModel _instance = SampleItemViewModel._();
  factory SampleItemViewModel() => _instance;
  SampleItemViewModel._();

  final List<SampleItem> items = [];

  void addItem(String name, [double price = 0.0]) {
    final newItem = SampleItem(name: name, price: price);
    items.add(newItem);
    notifyListeners();
  }

  void removeItem(String id) {
    final item = items.firstWhere(
      (item) => item.id == id,
      orElse: () => SampleItem(id: 'default', name: 'default'),
    );

    if (item != null) {
      items.remove(item);
      notifyListeners();
    } else {}
  }

  void updateItem(String id, String newName, [double? newPrice]) {
    final item = items.firstWhere(
      (item) => item.id == id,
      orElse: () => SampleItem(id: 'default', name: 'default'),
    );

    if (item != null) {
      item.name.value = newName;
      if (newPrice != null) {
        item.price.value = newPrice;
      }
      notifyListeners();
    } else {}
  }
}
