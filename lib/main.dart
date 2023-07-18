import 'package:flutter/material.dart';
import 'package:grocery_track/models/cart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Riverpod Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Riverpod Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // List of products
            Consumer(
              builder: (context, ref, child) {
                var productBox = ref.watch(productBoxProvider);

                return ListView.builder(
                  itemCount: productBox.length,
                  itemBuilder: (context, index) {
                    var product = productBox.getAt(index);
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('${product.price}\$'),
                      onTap: () {
                        // Add product to the shopping cart
                        ref.read(cartProvider).addProduct(product);
                      },
                    );
                  },
                );
              },
            ),

            // Shopping cart
            Card(
              child: ListTile(
                title: Text('Shopping Cart'),
                subtitle: Text('${ref.read(cartProvider).totalPrice}\$'),
                onTap: () {
                  // Go to the shopping cart screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final productBoxProvider = Provider<Box>(
  (ref) => Hive.box('products'),
);

final cartProvider = StateProvider<Cart>((ref) {
  return Cart();
});

