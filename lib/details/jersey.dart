import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sportpro/details/checkout.dart';
//import 'package:flutter_3d_view/flutter_3d_view.dart'; 

class details extends StatefulWidget {
  final String jerseyImage;
  final String jerseyName;
  final double price;
  final Function (CartItem) onAddToCart;

  const details({
    super.key, 
    required this.jerseyImage, 
    required this.jerseyName, 
    required this.price, 
    required this.onAddToCart,
  });

  @override
  _detailsState createState() => _detailsState();
}

class _detailsState extends State<details> with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  List<String> availableSizes = ['S', 'M', 'L', 'XL', 'XXL'];
  List<Color> availableColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.black,
    Colors.white
  ];

  String selectedSize = 'M';
  Color selectedColor = Colors.red;
   int _quantity = 1;
   int cartCount = 0;
   List<int> itemCounts = List.filled(10, 0);
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _quantityController.text = _quantity.toString();
  }
  void onAddToCart() {
    setState(() {
      print("the items are ");
      cartCount++;
    });
  }

  void decreaseCartCount (int index){
      if (itemCounts == 0 ){
        setState(() {
          cartCount--;
          itemCounts[index]--;
        });
      }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _quantityController.text = _quantity.toString();
    });
  }

  // Method to decrease quantity
  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
        _quantityController.text = _quantity.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        color: Colors.transparent,
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    // 3D Animated Jersey Image
                    Center(
                      child: AnimatedBuilder(
                        animation: _bounceController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 0.8 + (0.02 * sin(_bounceController.value * 1 * pi)),
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(widget.jerseyImage),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                      
                    // Jersey Name and Price
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.jerseyName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${widget.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Size',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: availableSizes.map((size) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedSize = size;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: selectedSize == size 
                                        ? Colors.blue 
                                        : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        color: selectedSize == size 
                                          ? Colors.white 
                                          : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                      
                    // Color Selection
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Color',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: availableColors.map((color) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedColor = color;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(25),
                                      border: selectedColor == color
                                        ? Border.all(color: Colors.blue, width: 3)
                                        : null,
                                    ),
                                    child: selectedColor == color 
                                    ? const Icon(Icons.check, color: Colors.white) 
                                    : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          const Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          // Minus Button
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _decrementQuantity,
                            color: Colors.blue,
                          ),
                          
                          // Quantity Input Field
                          SizedBox(
                            width: 60,
                            child: TextField(
                              controller: _quantityController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) {
                                // Validate and update quantity
                                int? newQuantity = int.tryParse(value);
                                if (newQuantity != null && newQuantity > 0) {
                                  setState(() {
                                    _quantity = newQuantity;
                                  });
                                }
                              },
                            ),
                          ),
                          
                          // Plus Button
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: _incrementQuantity,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                    
                    // Add to Cart Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          final cartItem = CartItem(
                            name: widget.jerseyName,
                            imageUrl: widget.jerseyImage,
                            price: widget.price,
                            color: selectedColor.toString().split('0x')[1].split(')')[0],
                            size: selectedSize,
                            quantity: _quantity,
                         
                          );
                      
                          print( widget.jerseyName);
                            print( widget.jerseyImage);
                            print(widget.price);
                            print(selectedSize);
                            print(selectedColor);
                            print(_quantity);
                           widget.onAddToCart(cartItem);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Item added to cart!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Add to Cart'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Usage in another widget
class JerseyPage extends StatelessWidget {
  const JerseyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          // Background content
          // Positioned.fill(
          //   child: Image.network(
          //     (widget.jerseyImage),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          
          // Jersey Details Sheet
          // JerseyDetailsSheet(
          //   jerseyImage: 'assets/jersey.png',
          //   jerseyName: 'Football Club Jersey',
          //   price: 79.99,
          // ),
        ],
      ),
    );
  }
}