import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:buoi06/Database/db_helper.dart';
import 'package:buoi06/model/sinhvien.dart';

class Bai1tailop extends StatelessWidget {
  const Bai1tailop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return manHinhDSSV();
  }
}

class manHinhDSSV extends StatefulWidget {
  const manHinhDSSV({Key? key}) : super(key: key);

  @override
  _manHinhDSSVState createState() => _manHinhDSSVState();
}

class _manHinhDSSVState extends State<manHinhDSSV> {
  late Future<List<SinhVien>> svs = Future.value([]);
  final DatabaseHelper db = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String searchText = "";

  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    List<SinhVien> sinhViens = await db.getSinhViens();
    if (sinhViens.isEmpty) {
      // Nếu danh sách trống, thêm một sinh viên mới
      SinhVien sv = SinhVien(name: "Nguyen Van A", email: "a@example.com");
      await db.insertSinhVien(sv);
      SinhVien sv1 = SinhVien(name: "Nguyen Van B", email: "b@example.com");
      await db.insertSinhVien(sv1);
    }
    // Cập nhật danh sách sinh viên lên giao diện
    try {
      setState(() {
        svs = db.getSinhViens(); // Gán trực tiếp Future
      });
      print("Dữ liệu sinh viên đã được tải.");
    } catch (e) {
      print("Lỗi khi tải dữ liệu sinh viên: $e");
    }
  }

  Future<void> _loadSinhVien() async {
    setState(() {
      svs = db.getSinhViens();
    });
  }

  Future<void> luuSV() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Dữ liệu hợp lệ!')));
      SinhVien sv = SinhVien(
        name: nameController.text,
        email: emailController.text,
      );
      await db
          .insertSinhVien(sv)
          .then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Thêm sinh viên thành công!')),
            );
            _loadSinhVien();
          })
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi khi thêm sinh viên: $error')),
            );
          });
      Navigator.of(context).pop();
    }
  }

  Future<void> themSV() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thêm sinh viên"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Tên sinh viên",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên sinh viên';
                      }
                      return null;
                    },
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Email"),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      } else if (!RegExp(
                        r'^[^@]+@[^@]+\.[^@]+',
                      ).hasMatch(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                luuSV();
              },
              child: const Text("Thêm"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
          ],
        );
      },
    );
  }

  Future<void> detailSV(SinhVien sv) async {
    nameController.text = sv.name;
    emailController.text = sv.email;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cập nhật sinh viên"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Tên sinh viên",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên sinh viên';
                      }
                      return null;
                    },
                    readOnly: true,
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Email"),
                    controller: emailController,

                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      } else if (!RegExp(
                        r'^[^@]+@[^@]+\.[^@]+',
                      ).hasMatch(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  sv.email = emailController.text;
                  db.updateSinhVien(sv);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cập nhật thành công!')),
                  );
                  _loadSinhVien();
                  nameController.clear();
                  emailController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Cập nhật"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                nameController.clear();
                emailController.clear();
              },
              child: const Text("Hủy"),
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
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Tìm kiếm sinh viên...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<SinhVien>>(
        future: svs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (searchText.isNotEmpty) {
            List<SinhVien> DSSV =
                snapshot.data!
                    .where(
                      (sv) => sv.name.toLowerCase().contains(
                        searchText.toLowerCase(),
                      ),
                    )
                    .toList();
            return ListView.builder(
              itemCount: DSSV.length,
              itemBuilder: (context, index) {
                SinhVien sv = DSSV[index];
                return ListTile(
                  leading: Image.asset('assets/images/logo.png'),
                  title: Text(
                    sv.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                  subtitle: Text(
                    sv.email,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  onTap: () {
                    detailSV(sv);
                  },
                  trailing: ElevatedButton(
                    onPressed: () {
                      db.deleteSinhVien(sv.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Xóa sinh viên thành công!')),
                      );
                      _loadSinhVien();
                    },
                    child: Icon(Icons.delete, color: Colors.red),
                  ),
                );
              },
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Chưa có thông tin sinh viên"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              SinhVien sv = snapshot.data![index];
              return Card(
                color: Colors.grey,
                child: ListTile(
                  leading: Image.asset('assets/images/logo.png'),
                  title: Text(
                    sv.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                  subtitle: Text(
                    sv.email,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  onTap: () {
                    detailSV(sv);
                  },
                  trailing: ElevatedButton(
                    onPressed: () {
                      db.deleteSinhVien(sv.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Xóa sinh viên thành công!')),
                      );
                      _loadSinhVien();
                    },
                    child: Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Thêm mới 1 sinh viên')));

          themSV();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
