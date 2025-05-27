import '../models/cart.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items => _items;

  CartProvider() {
    loadCartFromPrefs(); 
  }

  Future<void> saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = jsonEncode(_items.map((key, value) => MapEntry(key, value.toMap())));
    await prefs.setString('cart', cartJson);
  }

  Future<void> loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart');
    if (cartString != null) {
      final decoded = jsonDecode(cartString) as Map<String, dynamic>;
      _items = decoded.map((key, value) =>
          MapEntry(key, CartItem.fromMap(Map<String, dynamic>.from(value))));
      notifyListeners();
    }
  }

  void addItem(String productId, String title, double price) {
    if(_items.containsKey(productId)) {
      _items[productId]!.quantity += 1;
    } else {
      _items[productId] = CartItem(id: productId, title: title, quantity: 1, price: price);
    }
    notifyListeners();
    saveCartToPrefs();
  } 

  void removeItem(String productId) {
    _items.remove(productId);
    saveCartToPrefs(); 
    notifyListeners();
  }

 double get totalPrice => 
      _items.values.fold(0, (sum, item) => sum + (item.price * item.quantity));
}