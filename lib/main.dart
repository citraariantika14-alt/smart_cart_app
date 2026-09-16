import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider()..fetchProducts(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider()..fetchCartItems(), // Memuat isi keranjang dari SQLite saat app start
        ),
      ],
      child: MaterialApp(
        title: 'Smart-Cart SMKN 3 Tuban',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8C5427)),
          useMaterial3: true,
        ),
        home: const CatalogScreen(),
      ),
    );
  }
}