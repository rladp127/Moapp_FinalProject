class Product {
  const Product({
    required this.name,
    required this.price,
    required this.location,
    required this.url,
    required this.detail,
    required this.owner
  });

  final String name;
  final int price;
  final String location;
  final String url;
  final String detail;
  final String owner;

  // @override
  // String toString() => "$name (id=$id)";
}