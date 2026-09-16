import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String formatTanpaTitik(dynamic price) {
    if (price is num) {
      return 'Rp ${price.toInt()}';
    }
    String str = price.toString().replaceAll('.', '').replaceAll(',', '');
    return 'Rp $str';
  }

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF8C5427);
    const lightBg = Color(0xFFF8F7F5);

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: lightBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final cartItems = cartProvider.cartItems;

          if (cartItems.isEmpty) {
            return const Center(
              child: Text(
                'Keranjang belanja Anda kosong',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatTanpaTitik(item.price),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: primaryBrown),
                                onPressed: () {
                                  cartProvider.updateQuantity(
                                      item.id, item.quantity - 1);
                                },
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline,
                                    color: primaryBrown),
                                onPressed: () {
                                  cartProvider.updateQuantity(
                                      item.id, item.quantity + 1);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                onPressed: () {
                                  cartProvider.removeItem(item.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pembayaran:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatTanpaTitik(cartProvider.totalAmount),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryBrown,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}