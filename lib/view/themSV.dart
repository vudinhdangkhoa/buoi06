import 'package:flutter/material.dart';
import 'package:buoi06/model/sinhvien.dart';
import '../database/db_helper.dart';

class AddSinhVien extends StatefulWidget {
  const AddSinhVien({super.key});

  @override
  State<AddSinhVien> createState() => _AddSinhVienSate();
}

class _AddSinhVienSate extends State<AddSinhVien> {
  TextEditingController _txtTen = TextEditingController();
  TextEditingController _txtEmail = TextEditingController();
  final FocusNode _focusTen =
      FocusNode(); // FocusNode để đặt con trỏ vào TextField
  final DatabaseHelper db = DatabaseHelper();

  Future<void> _saveSinhVien() async {
    String name = _txtTen.text.trim();
    String email = _txtEmail.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    SinhVien sv = SinhVien(name: name, email: email);
    await db.insertSinhVien(sv);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Lưu sinh viên thành công!")));

    //Navigator.pop(context); // Quay lại màn hình trước
    _txtTen.clear();
    _txtEmail.clear();
    //FocusScope.of(context).requestFocus(_focusTen); // Đưa con trỏ về ô nhập tên
  }

  @override
  void dispose() {
    _txtTen.dispose();
    _txtEmail.dispose();
    _focusTen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
              true,
            ); // Quay về màn hình trước và báo cần cập nhật danh sách
          },
        ),
        title: const Text(
          'Thêm sinh viên: ',
          style: TextStyle(color: Color.fromRGBO(15, 100, 197, 1)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Lưu sinh viên',
            onPressed: () {
              _saveSinhVien();
              //gọi phương thức add trong db_hepper
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_before),
            tooltip: 'Go to home page',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(title: const Text('Home page')),
                      body: const Center(
                        child: Text(
                          'This is home page',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            //các textfield
            TextField(
              controller: _txtTen,
              decoration: const InputDecoration(
                labelText: "Nhập tên",
                hintText: "Nhập tên của bạn...",
                prefixIcon: Icon(Icons.abc),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            //các textfield
            TextField(
              controller: _txtEmail,
              decoration: const InputDecoration(
                labelText: "Nhập email",
                hintText: "Nhập email của bạn...",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
