import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemList = cartProvider.items.values.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Card Total Pembayaran Atas
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5E3C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Rp ${cartProvider.totalAmount.toInt()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Daftar Item Keranjang
            Expanded(
              child: cartItemList.isEmpty
                  ? const Center(child: Text('Keranjang kosong'))
                  : ListView.builder(
                      itemCount: cartItemList.length,
                      itemBuilder: (ctx, i) {
                        final item = cartItemList[i];
                        return Card(
                          elevation: 0,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Gambar Produk Berdasarkan Judul/Title Produk
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[100],
                                    child: item.title.toLowerCase().contains('tas')
                                        ? Image.asset('assets/tas.png', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag))
                                        : item.title.toLowerCase().contains('lampu')
                                            ? Image.asset('assets/lampu.png', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.lightbulb))
                                            : const Icon(Icons.shopping_bag, color: Color(0xFF8B5E3C)),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Nama Produk & Subtitle Total
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Total: Rp ${(item.price * item.quantity).toInt()}',
                                        style: TextStyle(
                                          color: Colors.brown[300],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Kontrol Tombol Minus, Angka Jumlah (1x/2x), dan Plus
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 20, color: Colors.black87),
                                      onPressed: () {
                                        cartProvider.removeSingleItem(item.id);
                                      },
                                    ),
                                    SizedBox(
                                      width: 28,
                                      child: Text(
                                        '${item.quantity}x',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 20, color: Colors.black87),
                                      onPressed: () {
                                        // Memanggil addItem sesuai 3 parameter asli laporan: (id, price, title)
                                        cartProvider.addItem(
                                          item.id,
                                          item.price,
                                          item.title,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}