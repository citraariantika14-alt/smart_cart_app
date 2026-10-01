class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    this.imageUrl = '',
  });

  // Untuk mengonversi objek CartItem ke Map (disimpan ke SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Untuk mengonversi Map dari SQLite menjadi objek CartItem
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      quantity: map['quantity'] ?? 1,
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}