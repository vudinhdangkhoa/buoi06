class CongViec {
  String? tenCV;
  String? moTa;
  String? trangthai;
  int? id;
  CongViec({
    this.id,
    required this.tenCV,
    required this.moTa,
    required this.trangthai,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': tenCV, 'content': moTa, 'status': trangthai};
  }

  factory CongViec.fromMap(Map<String, dynamic> map) {
    return CongViec(
      tenCV: map['tenCV'],
      moTa: map['moTa'],
      trangthai: map['trangthai'],
      id: map['id'],
    );
  }
}
