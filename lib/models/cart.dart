import 'package:grocery_track/models/products.dart';

class Cart {
  List<Product> products = [];

  void addProduct(Product product) {
    products.add(product);
  }

  double get totalPrice {
    double total = 0.0;
    for (var product in products) {
      total += product.price;
    }
    return total;
  }
}