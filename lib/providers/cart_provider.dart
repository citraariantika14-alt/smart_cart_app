import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../helpers/db_helper.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> fetchAndSetCartItems() async {
    final dataList = await DBHelper.getCartItems();
    final Map<String, CartItem> loadedItems = {};
    for (var item in dataList) {
      loadedItems[item['id']] = CartItem.fromMap(item);
    }
    _items = loadedItems;
    notifyListeners();
  }

  Future<void> addItem(String productId, double price, String title) async {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
    await DBHelper.insertCartItem({
      'id': productId,
      'title': title,
      'quantity': _items[productId]!.quantity,
      'price': price,
    });
  }

  Future<void> removeSingleItem(String productId) async {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
      await DBHelper.insertCartItem({
        'id': productId,
        'title': _items[productId]!.title,
        'quantity': _items[productId]!.quantity,
        'price': _items[productId]!.price,
      });
    } else {
      _items.remove(productId);
      await DBHelper.deleteCartItem(productId);
    }
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    _items.remove(productId);
    notifyListeners();
    await DBHelper.deleteCartItem(productId);
  }

  Future<void> clear() async {
    _items = {};
    notifyListeners();
    await DBHelper.clearCart();
  }
}