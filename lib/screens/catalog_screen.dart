import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  // Fungsi khusus menghapus semua titik pada harga
  String formatTanpaTitik(dynamic price) {
    if (price is num) {
      return 'Rp ${price.toInt()}';
    }
    String str = price.toString().replaceAll('.', '').replaceAll(',', '');
    return 'Rp $str';
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProductProvider>(context, listen: false).fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF8C5427);
    const lightBtnBg = Color(0xFFF2ECE4);
    const lightBg = Color(0xFFF8F7F5);

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: lightBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false, // Mengunci judul agar tetap di pinggir kiri (sesuai acuan)
        titleSpacing: 16,
        title: const Text(
          'Katalog Produk SMKN 3 Tuban',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.black, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartScreen()),
                      );
                    },
                  ),
                  if (cart.cartItems.isNotEmpty)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: primaryBrown,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          '${cart.cartItems.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.products;

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: products.length + 1,
            itemBuilder: (context, index) {
              if (index == products.length) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () => _showAddProductDialog(context),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryBrown,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '+ Tambah Produk',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }

              final product = products[index];

              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          product.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            child: const Icon(Icons.inventory_2_outlined,
                                size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatTanpaTitik(product.price),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightBtnBg,
                          foregroundColor: primaryBrown,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          Provider.of<CartProvider>(context, listen: false)
                              .addItem(
                            product.id,
                            product.name,
                            product.price,
                            product.imageUrl,
                          );
                        },
                        icon: const Icon(Icons.shopping_cart_outlined,
                            size: 16, color: primaryBrown),
                        label: const Text(
                          'Tambah',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: primaryBrown,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Produk Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk')),
            TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga Produk')),
            TextField(
                controller: imageController,
                decoration: const InputDecoration(
                    labelText: 'Path Gambar (contoh: assets/meja.png)')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                Provider.of<ProductProvider>(context, listen: false).addProduct(
                  nameController.text,
                  double.parse(priceController.text),
                  imageController.text,
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}