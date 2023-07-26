class Product {
  int? id;
  final String? name;
  final double? price;
  final double? discount;
  final double? weight;
  final String? image;

  Product({this.id, this.name, this.price, this.weight, this.image, this.discount});

  @override
  List<Object?> get props => [
    name,
    price,
    discount,
    weight,
    image
  ];

  factory Product.fromJson(Map<String, dynamic> json)=> Product(
    id: json['productId'],
    name: json['name'],
    price: json['price'],
    weight: json['weight'],
    image: json['image'],
    discount: json['discount'],
  );

  Map<String, dynamic> toJson() =>{
    'productId': id,
    'name': name,
    'price': price,
    'weight' : weight,
    'image' : image,
    'discount' : discount
  };
}