class ChiTieu {
  int? id;
  String? titel;
  String? note;
  double? price;
  ChiTieu({
    this.id,
    required this.titel,
    required this.note,
    required this.price,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'id: $id \ntitel: $titel \nnote: $note \nprice: $price';
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'titel': titel, 'price': price, 'note': note};
  }

  factory ChiTieu.fromMap(Map<String, dynamic> map) {
    return ChiTieu(
      id: map['id'],
      titel: map['titel'],
      note: map['note'],
      price: map['price'],
    );
  }
}
