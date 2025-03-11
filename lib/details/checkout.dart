import 'package:flutter/material.dart';

class CartItem {
  final String imageUrl;
  final String? name;
  final double price;
  final String color;
  final int quantity;
  final String size;

  double get totalPrice => price * quantity;

  CartItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.color,
    required this.quantity,
    required this.size,
  });
}

class Checkout extends StatelessWidget {
  final List<CartItem> cartItems;
 
  const Checkout({super.key, required this.cartItems});
  

  @override
  Widget build(BuildContext context) {
     print("The Checkout cart items length is ${cartItems.length}");

    double total = cartItems.fold(0, (sum, item) => sum + item.totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  ),
                  child: ListTile(
                    leading: Image.network(item.imageUrl),
                    title: Text(
                      "Size: ${item.size}, Color: ${item.color}, Quantity: ${item.quantity}",
                    ),
                    subtitle: Text(
                      "\$${item.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Item'),
                              content: const Text('Are you sure you want to remove this item from cart?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text('Yes', style: TextStyle(color: Colors.red)),
                                  onPressed: () {
                                    cartItems.removeAt(index);
                                    Navigator.pop(context);
                                    // setState(() {
                                    //   cartCount--;
                                    // });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.delete)
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Price:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${total.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                
              },
              child: const Text("Proceed to Payment"),
            ),
          ),
        ],
      ),
    );
  }
}

