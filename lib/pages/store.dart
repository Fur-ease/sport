import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sportpro/details/checkout.dart';
import 'package:sportpro/details/jersey.dart';
import 'package:sportpro/try/try.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> with SingleTickerProviderStateMixin{
  late final PreferencesService _prefsService;
  int cartCount = 0;
  int favoriteCount = 0;

  
  final Stream<QuerySnapshot> imageStream =
      FirebaseFirestore.instance.collection('images').snapshots();
   
  
  List<int> favoritedItems = [];
  List <CartItem> cartItems = [];
  List<int> itemCounts = List.filled(10, 0);

  Future<void> _loadSavedData() async {
    final savedCartItems = _prefsService.getCartItems();
    final savedFavorites = _prefsService.getFavoriteItems();
    setState(() {
      // Load your saved data
    });
  }

  Future<void> addImageLink(String imageUrl) {
  CollectionReference images = FirebaseFirestore.instance.collection('images');
  return images.add({
    'images': imageUrl,

  });
}
  // CollectionReference<Object?> getItems () {
  //   CollectionReference picture = FirebaseFirestore.instance.collection('images');
  //   return picture;
  // }

  

  void incrementCartCount(int index) {
    setState(() {
      print("Previous cart length is ${cartItems.length}");
      cartCount++;
     // itemCounts[index]++;
      
    });
  }
    void onAddToCart(CartItem item) {
      bool itemExists = cartItems.any((cartItem) => 
        cartItem.imageUrl == item.imageUrl && 
        cartItem.size == item.size && 
        cartItem.color == item.color
      );

      if (itemExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This item is already in your cart'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        setState(() {
          cartCount++;
          cartItems.add(item);
        });
      }
    }
  void decreaseCartCount (int index){
      if (itemCounts == 0 ){
        setState(() {
          cartCount--;
          itemCounts[index]--;
        });
      }
  }

  void toggleFavorite(int index) {
    setState(() {
      if (favoritedItems.contains(index)) {
        favoritedItems.remove(index);
        favoriteCount--;
      } else {
        favoritedItems.add(index);
        favoriteCount++;
      }
    });
  }

  late Future<String> getItpicItemsemsFuture;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    //ReadData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return Future.value(false);
      },
      child: Scaffold(
        body: content(
          onAddToCart: incrementCartCount,
          onToggleFavorite: toggleFavorite,
          cartCount: cartCount,
          favoriteCount: favoriteCount,
          favoritedItems: favoritedItems,
          itemCounts: itemCounts, 
          onRemoveFromCart: decreaseCartCount,
        ),
      ),
    );
  }
Widget content({
  required Function onAddToCart,
  required Function onRemoveFromCart,
  required Function onToggleFavorite,
  required int cartCount,
  required int favoriteCount,
  required List<int> favoritedItems,
  required List<int> itemCounts,
}) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                 //Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios),
              ),
              const SizedBox(width: 20),
              const Text('Shop'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Checkout(
                          cartItems: cartItems,
                        )
                      ));
                    },
                    child: const Icon(Icons.shopping_cart),
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: (){
                           if (cartItems.isNotEmpty) {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => Checkout(cartItems: cartItems)
                              )
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cart is empty'))
                            );
                          }
                        //   print("The Store cart items length is ${cartItems.length}");
                        //     Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) => Checkout(
                        //     cartItems: cartItems,
                        //   )
                        // ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.favorite_outline),
                  ),
                  if (favoriteCount > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$favoriteCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          )
        ],
      ),
    ),
    body: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: imageStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              }
              final images = snapshot.data!.docs;
              return GridView.builder(
                shrinkWrap: true,
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.85
                ),
                itemBuilder: (context, index) {
                  bool isFavorited = favoritedItems.contains(index);
                  int itemCount = itemCounts[index];
                  String imageUrl = images[index]['images'];
                  
                  return InkWell(
                    onDoubleTap: () => onToggleFavorite(index),
                    onTap: () {
                      showModalBottomSheet(
                      context: context,
                      isScrollControlled: true, 
                      backgroundColor: Colors.transparent,
                      builder: (context) => details(
                        jerseyImage: imageUrl,
                           jerseyName: '', 
                           price: 20, 
                           onAddToCart: (CartItem ) { 
                            setState(() {
                              cartItems.add(CartItem);
                              cartCount++;
                            });
                            incrementCartCount(index); 
                            },
                           //onAddToCart: incrementCartCount,
                           )
                      );
                    
                      // Navigator.push(
                      //   context, 
                      // MaterialPageRoute(
                      //   builder: (context) => const details(
                      //     jerseyImage: '', 
                      //     jerseyName: '', 
                      //     price: 20,
                      //     )
                      //   )
                      // );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                 image: CachedNetworkImageProvider(imageUrl),
                                  fit: BoxFit.cover, 
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () => onToggleFavorite(index),
                              child: Icon(
                                isFavorited 
                                  ? Icons.favorite 
                                  : Icons.favorite_border_outlined,
                                color: isFavorited ? Colors.red : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          ),
        ),
      ),
    ),
  );
}
}
