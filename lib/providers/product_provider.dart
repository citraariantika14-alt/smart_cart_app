import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: 1,
      name: 'Meja Belajar',
      price: 650000,
      imageUrl: 'assets/meja.png',
    ),
    Product(
      id: 2,
      name: 'Kursi Ergonomis',
      price: 350000,
      imageUrl: 'assets/kursi.png',
    ),
    Product(
      id: 3,
      name: 'Rak Buku 3 Susun',
      price: 425000,
      imageUrl: 'assets/rak.png',
    ),
    Product(
      id: 4,
      name: 'Lampu Meja LED',
      price: 150000,
      imageUrl: 'assets/lampu.png',
    ),
    Product(
      id: 5,
      name: 'Tas Ransel Sekolah',
      price: 200000,
      imageUrl: 'assets/tas.png',
    ),
  ];

  List<Product> get products => [..._products];

  Future<void> fetchProducts() async {
    notifyListeners();
  }

  Future<void> addProduct(String name, double price, String imageUrl) async {
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      price: price,
      imageUrl: imageUrl.isEmpty ? 'assets/meja.png' : imageUrl,
    );
    _products.add(newProduct);
    notifyListeners();
  }
}