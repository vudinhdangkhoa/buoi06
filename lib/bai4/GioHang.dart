import 'package:flutter/material.dart';

import 'ListView.dart';

class DSGioHang extends StatefulWidget {
  const DSGioHang({Key? key}) : super(key: key);

  @override
  _DSGioHangState createState() => _DSGioHangState();
}

class _DSGioHangState extends State<DSGioHang> {
  static List<DienThoai> lstGioHang = GioHang.lstGioHang;
  void xoaGioHang() {
    setState(() {
      lstGioHang.clear();
    });
  }

  double tinhTongGiaTri() {
    return lstGioHang.fold(0, (sum, item) => sum + item.gia);
  }

  void ThanhToan() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text(
            'Bạn có muốn thanh toán  ${tinhTongGiaTri().toString()}',
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
                Navigator.pop(context);
                xoaGioHang();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void xoaSanPham(int index, DienThoai dienThoai) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text('Bạn vừa xóa ${dienThoai.ten} khỏi giỏ hàng'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('không'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  lstGioHang.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return lstGioHang.isEmpty
        ? Column(
          children: [
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Giỏ hàng của bạn đang trống',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('thanh toán', textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
          ],
        )
        : Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: lstGioHang.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.asset(lstGioHang[index].hinh),
                      title: Text(lstGioHang[index].ten),
                      subtitle: Text(lstGioHang[index].gia.toString()),
                      trailing: IconButton(
                        onPressed: () {
                          xoaSanPham(index, lstGioHang[index]);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      ThanhToan();
                    },
                    child: Text('thanh toán', textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
          ],
        );
  }
}

class TrangGioHang extends StatelessWidget {
  const TrangGioHang({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Giỏ hàng'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Center(
              child: Text('Giỏ hàng của bạn', style: TextStyle(fontSize: 25)),
            ),
          ),
          Expanded(child: DSGioHang()),
        ],
      ),
    );
  }
}
