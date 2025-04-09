class Sanpham {
  int? id;
  String? name;
  double? price;
  double? sale;
  Sanpham({
    this.id,
    required this.name,
    required this.price,
    required this.sale,
  });

  double getTax() {
    if (price == null) {
      return 0.0;
    }
    return price! * 0.1;
  }

  @override
  String toString() {
    return 'id: $id \nname: $name \nprice: $price \nsale: $sale \ntax: ${getTax()}';
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price, 'sale': sale};
  }

  factory Sanpham.fromMap(Map<String, dynamic> map) {
    return Sanpham(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      sale: map['sale'],
    );
  }
}
