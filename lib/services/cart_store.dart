import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartStore extends ChangeNotifier {
  static const String _storageKey = 'mini_catalog_cart';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  final Map<int, CartItem> _items = {};

  Future<void> _pendingSave = Future<void>.value();

  List<CartItem> get items => List.unmodifiable(_items.values);

  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.values.fold(0.0, (sum, item) => sum + item.subtotal);

  Future<void> load(List<Product> products) async {
    final saved = await _prefs.getString(_storageKey);

    _items.clear();

    if (saved == null) {
      notifyListeners();
      return;
    }

    try {
      final decoded = jsonDecode(saved) as List<dynamic>;

      final productMap = {for (final product in products) product.id: product};

      for (final entry in decoded) {
        final data = entry as Map<String, dynamic>;

        final id = (data['productId'] as num).toInt();
        final quantity = (data['quantity'] as num).toInt();

        final product = productMap[id];

        if (product != null && quantity > 0) {
          _items[id] = CartItem(product: product, quantity: quantity);
        }
      }
    } on FormatException catch (error) {
      debugPrint('Sepet JSON hatası: $error');
      _items.clear();
    } on TypeError catch (error) {
      debugPrint('Sepet veri tipi hatası: $error');
      _items.clear();
    }

    notifyListeners();
  }

  void add(Product product) {
    final existing = _items[product.id];

    if (existing != null) {
      existing.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }

    notifyListeners();
    _save();
  }

  void decrease(int productId) {
    final item = _items[productId];
    if (item == null) return;

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(productId);
    }

    notifyListeners();
    _save();
  }

  void remove(int productId) {
    if (_items.remove(productId) == null) return;

    notifyListeners();
    _save();
  }

  void clear() {
    if (_items.isEmpty) return;

    _items.clear();
    notifyListeners();
    _save();
  }

  void _save() {
    final data = _items.values.map((item) {
      return {'productId': item.product.id, 'quantity': item.quantity};
    }).toList();

    final snapshot = jsonEncode(data);

    _pendingSave = _pendingSave
        .then((_) => _prefs.setString(_storageKey, snapshot))
        .catchError((Object error) {
          debugPrint('Sepet kaydedilemedi: $error');
        });
  }
}
