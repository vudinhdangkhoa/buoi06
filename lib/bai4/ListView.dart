import 'package:flutter/material.dart';

class DienThoai {
  String ten;
  String hinh;
  int gia;
  String mota;
  DienThoai({
    required this.ten,
    required this.hinh,
    required this.gia,
    required this.mota,
  });
}

class GioHang {
  static List<DienThoai> lstGioHang = [];
}

class GiaoDienLstView extends StatelessWidget {
  DienThoai dienThoai;
  GiaoDienLstView({Key? key, required this.dienThoai}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 320,
        height: 400,

        margin: EdgeInsets.only(top: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),

                width: 150,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(dienThoai.hinh),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                dienThoai.ten,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(dienThoai.mota, style: TextStyle(fontSize: 15)),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 70,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 20,
                    child: Text(
                      '${dienThoai.gia.toString()}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Xác nhận'),
                                  content: Text(
                                    'Bạn vừa thêm sản phẩm vòa giỏ hàng',
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('không'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        GioHang.lstGioHang.add(dienThoai);
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LstDienThoai extends StatefulWidget {
  const LstDienThoai({Key? key}) : super(key: key);

  @override
  _LstDienThoaiState createState() => _LstDienThoaiState();
}

class _LstDienThoaiState extends State<LstDienThoai> {
  static List<DienThoai> lstDienThoai = [
    DienThoai(
      ten: 'sach 2',
      hinh: 'assets/images/sach2.jpg',
      gia: 2000,
      mota: 'sách 2',
    ),
    DienThoai(
      ten: 'sach 3',
      hinh: 'assets/images/sach3.jpg',
      gia: 3000,
      mota: 'sách 3',
    ),
    DienThoai(
      ten: 'sach 4',
      hinh: 'assets/images/sach4.jpg',
      gia: 4000,
      mota: 'sách 4',
    ),
    DienThoai(
      ten: 'sach 5',
      hinh: 'assets/images/sach5.jpg',
      gia: 5000,
      mota: 'sách 5',
    ),
    DienThoai(
      ten: 'sach 6',
      hinh: 'assets/images/sach6.jpg',
      gia: 6000,
      mota: 'sách 6',
    ),
    DienThoai(
      ten: 'sach 7',
      hinh: 'assets/images/sach7.jpg',
      gia: 7000,
      mota: 'sách 7',
    ),
    DienThoai(
      ten: 'sach 8',
      hinh: 'assets/images/sach8.jpg',
      gia: 8000,
      mota: 'sách 8',
    ),
    DienThoai(
      ten: 'sach 9',
      hinh: 'assets/images/scah9.jpg',
      gia: 9000,
      mota: 'sách 9',
    ),
    DienThoai(
      ten: 'sach 10',
      hinh: 'assets/images/sach10.jpg',
      gia: 10000,
      mota: 'sách 10',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: lstDienThoai.length,
        itemBuilder: (context, index) {
          return GiaoDienLstView(dienThoai: lstDienThoai[index]);
        },
      ),
    );
  }
}
