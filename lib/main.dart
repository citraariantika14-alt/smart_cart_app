import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()..fetchProducts()),
        // Menggunakan fetchAndSetCartItems() sesuai fungsi di cart_provider.dart laporan
        ChangeNotifierProvider(create: (_) => CartProvider()..fetchAndSetCartItems()),
      ],
      child: MaterialApp(
        title: 'Smart Cart SQLite',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CatalogScreen(),
      ),
    );
  }
}