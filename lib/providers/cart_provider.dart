import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../helpers/db_helper.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  double get totalAmount {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Ambil seluruh isi keranjang dari SQLite
  Future<void> fetchCartItems() async {
    final data = await DBHelper.getCartItems();
    _cartItems = data.map((item) => CartItem.fromMap(item)).toList();
    notifyListeners();
  }

  // Tambah produk ke keranjang SQLite
  Future<void> addItem(dynamic productId, String name, double price, String imageUrl) async {
    final existingIndex = _cartItems.indexWhere((item) => item.name == name);

    if (existingIndex >= 0) {
      final existingItem = _cartItems[existingIndex];
      final newQty = existingItem.quantity + 1;
      await DBHelper.updateCartQuantity(existingItem.id, newQty);
    } else {
      final newItem = {
        'id': productId is int ? productId : DateTime.now().millisecondsSinceEpoch,
        'name': name,
        'price': price,
        'quantity': 1,
      };
      await DBHelper.insertCart(newItem);
    }
    await fetchCartItems(); // Re-fetch data dari SQLite
  }

  // Ubah kuantitas (+ / -) di SQLite
  Future<void> updateQuantity(dynamic id, int newQuantity) async {
    if (newQuantity <= 0) {
      await DBHelper.deleteCartItem(id);
    } else {
      await DBHelper.updateCartQuantity(id, newQuantity);
    }
    await fetchCartItems();
  }

  // Hapus item dari SQLite
  Future<void> removeItem(dynamic id) async {
    await DBHelper.deleteCartItem(id);
    await fetchCartItems();
  }
}