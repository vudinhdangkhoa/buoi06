import 'package:flutter/material.dart';
import 'package:buoi06/Database/db_Bai4.dart';
import 'package:buoi06/model/chitieu.dart';

class Bai4 extends StatelessWidget {
  const Bai4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bai4Screen();
  }
}

class Bai4Screen extends StatefulWidget {
  const Bai4Screen({Key? key}) : super(key: key);

  @override
  _Bai4ScreenState createState() => _Bai4ScreenState();
}

class _Bai4ScreenState extends State<Bai4Screen> {
  final DB_bai4 db = DB_bai4();
  late Future<List<ChiTieu>> lstct = Future.value([]);
  final GlobalKey<FormState> _formkey = GlobalKey();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    List<ChiTieu> DSCT = await db.getChiTieu();
    if (DSCT.isEmpty) {
      ChiTieu ct1 = ChiTieu(
        titel: 'Mua sắm',
        price: 1000,
        note: 'Mua sắm đồ dùng cá nhân',
      );
      ChiTieu ct2 = ChiTieu(
        titel: 'Ăn uống',
        price: 500,
        note: 'Ăn uống hàng ngày',
      );
      ChiTieu ct3 = ChiTieu(titel: 'Giải trí', price: 200, note: 'Đi xem phim');
      await db.insertChiTieu(ct1);
      await db.insertChiTieu(ct2);
      await db.insertChiTieu(ct3);
    }
    try {
      setState(() {
        lstct = db.getChiTieu();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), duration: Duration(seconds: 2)),
      );
    }
  }

  Future<void> loadChiTieu() async {
    setState(() {
      lstct = db.getChiTieu();
    });
  }

  Future<void> addChiTieu() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('them Chi Tiêu'),
          content: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tiêu đề',
                      border: OutlineInputBorder(),
                    ),
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tiêu đề';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Ghi chú',
                      border: OutlineInputBorder(),
                    ),
                    controller: _noteController,
                    validator: (value) {
                      if (_noteController.text.isEmpty) {
                        return 'Vui lòng nhập ghi chú';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Giá',
                      border: OutlineInputBorder(),
                    ),
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (_priceController.text.isEmpty) {
                        return 'Vui lòng nhập giá';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  String title = _titleController.text;
                  String note = _noteController.text;
                  double price = double.parse(_priceController.text);
                  ChiTieu newChiTieu = ChiTieu(
                    titel: title,
                    note: note,
                    price: price,
                  );
                  await db.insertChiTieu(newChiTieu).then((value) {
                    loadChiTieu();
                    Navigator.of(context).pop();
                    _noteController.clear();
                    _priceController.clear();
                    _titleController.clear();
                  });
                }
              },
              child: Text('Thêm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _noteController.clear();
                _priceController.clear();
                _titleController.clear();
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 4'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              //loadChiTieu();
              db.debugTables();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ChiTieu>>(
        future: lstct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  await db.deleteDatabaseFile();
                },
                child: Text('Debug'),
              ),
            );
          } else {
            final chiTieuList = snapshot.data!;
            return ListView.builder(
              itemCount: chiTieuList.length,
              itemBuilder: (context, index) {
                final chiTieu = chiTieuList[index];
                return ListTile(
                  leading: Icon(
                    Icons.monetization_on_rounded,
                    color: Colors.pinkAccent,
                  ),
                  title: Text(
                    chiTieu.titel ?? '',
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Text('Giá: ${chiTieu.price}'),

                  trailing: Icon(Icons.delete, color: Colors.red),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Chi tiết Chi Tiêu'),
                          content: Center(child: Text(chiTieu.toString())),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('đóng'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addChiTieu();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
