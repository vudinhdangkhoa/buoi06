import 'package:flutter/material.dart';
import 'trangchinh.dart';

class Bai4trenlop extends StatelessWidget {
  const Bai4trenlop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              'Cửa hàng điện thoại',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Text(
              '140 Lê trọng Tấn,Tân Phú,TP.Hồ Chí Minh',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Trangchinh()),
                );
              },
              child: Icon(Icons.arrow_right_alt_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
