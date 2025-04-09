import 'package:buoi06/view/bai2tailop/add_todo.dart';
import 'package:flutter/material.dart';
import 'package:buoi06/Database/db_ToDo.dart';
import 'package:buoi06/model/congviec.dart';

class Bai2tailop extends StatelessWidget {
  const Bai2tailop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ManHinhToDo();
  }
}

class ManHinhToDo extends StatefulWidget {
  const ManHinhToDo({Key? key}) : super(key: key);

  @override
  _ManHinhToDoState createState() => _ManHinhToDoState();
}

class _ManHinhToDoState extends State<ManHinhToDo> {
  DbTodo db = DbTodo();
  late Future<List<CongViec>> cv = Future.value([]);
  bool isCheck = false;
  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    List<CongViec> congViecs = await db.getCongViecs();
    if (congViecs.isEmpty) {
      CongViec cv2 = CongViec(
        tenCV: "Công việc 1",
        moTa: "Mô tả công việc 1",
        trangthai: "Chưa hoàn thành",
      );
      await db.insertCongViec(cv2);
      CongViec cv1 = CongViec(
        tenCV: "Công việc 2",
        moTa: "Mô tả công việc 2",
        trangthai: "Chưa hoàn thành",
      );
      await db.insertCongViec(cv1);
    }
    try {
      setState(() {
        cv = db.getCongViecs();
      });
    } catch (e) {
      print("Lỗi khi tải dữ liệu công việc: $e");
    }
  }

  Future<void> _loadCongViec() async {
    setState(() {
      cv = db.getCongViecs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo")),
      body: FutureBuilder<List<CongViec>>(
        future: cv,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi khi tải dữ liệu công việc"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Không có công việc nào"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              CongViec cviec = snapshot.data![index];
              return ListTile(
                leading: IconButton(
                  onPressed: () {
                    setState(() {
                      if (cviec.trangthai == "Hoàn thành") {
                        cviec.trangthai = "Chưa hoàn thành";
                      } else {
                        cviec.trangthai = "Hoàn thành";
                      }
                      db.updateCongViec(cviec);
                    });
                  },
                  icon: Icon(
                    cviec.trangthai == 'Hoàn thành'
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                  ),
                ),
                title: Text(cviec.tenCV!),
                subtitle: Column(
                  children: [Text(cviec.moTa!), Text(cviec.trangthai!)],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await db.deleteCongViec(cviec.id!);
                    _loadCongViec();
                  },
                  color: Colors.red,
                ),
                onTap: () {},
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => add_todo()),
          );
          if (result == true) {
            _loadCongViec();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
