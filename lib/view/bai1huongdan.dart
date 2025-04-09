import 'package:buoi06/view/themSV.dart';
import 'package:flutter/material.dart';
import 'package:buoi06/Database/db_helper.dart';

import '../model/sinhvien.dart';

class Bai1 extends StatelessWidget {
  const Bai1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SinhVienListScreen00();
  }
}

class SinhVienListScreen00 extends StatefulWidget {
  const SinhVienListScreen00({Key? key}) : super(key: key);

  @override
  _SinhVienListScreen00State createState() => _SinhVienListScreen00State();
}

class _SinhVienListScreen00State extends State<SinhVienListScreen00> {
  late Future<List<SinhVien>> svs = Future.value([]);
  final DatabaseHelper db = DatabaseHelper();
  @override
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách sinh viên"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Thêm sinh viên',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddSinhVien()),
              );
              if (result == true) {
                _loadSinhVien(); // Cập nhật danh sách nếu có sinh viên mới
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thêm mới 1 sinh viên')),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<SinhVien>>(
        future: svs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Chưa có thông tin sinh viên"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              SinhVien sv = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(
                    sv.name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    sv.email,
                    style: TextStyle(color: Colors.lightBlue),
                  ),

                  trailing: Icon(Icons.email, color: Colors.blue),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Bai1huongdan extends StatefulWidget {
  const Bai1huongdan({Key? key}) : super(key: key);

  @override
  _Bai1huongdanState createState() => _Bai1huongdanState();
}

class _Bai1huongdanState extends State<Bai1huongdan> {
  late Future<List<SinhVien>> svs;
  final DatabaseHelper db = DatabaseHelper();

  Future<void> _initDatabase() async {
    List<SinhVien> sinhViens = await db.getSinhViens();
    // Cập nhật danh sách sinh viên lên giao diện
    setState(() {
      try {
        setState(() {
          svs = db.getSinhViens();
        });
        print("Dữ liệu sinh viên đã được tải.");
      } catch (e) {
        print("Lỗi khi tải dữ liệu sinh viên: $e");
      }
    });
  }

  Future<void> _loadSinhVien() async {
    List<SinhVien> list = await db.getSinhViens();
    setState(() {
      svs = list as Future<List<SinhVien>>;
    });
  }

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách sinh viên"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Thêm sinh viên',
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thêm mới 1 sinh viên')),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<SinhVien>>(
        future: svs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Chưa có thông tin sinh viên"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              SinhVien sv = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(
                    sv.name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    sv.email,
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                  trailing: Icon(Icons.email, color: Colors.blue),
                ),
              );
              const Divider();
            },
          );
        },
      ),
    );
  }
}
