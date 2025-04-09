import 'package:flutter/material.dart';
import 'package:buoi06/Database/db_ToDo.dart';
import 'package:buoi06/model/congviec.dart';

class add_todo extends StatelessWidget {
  const add_todo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _addScreen();
  }
}

class _addScreen extends StatefulWidget {
  const _addScreen({Key? key}) : super(key: key);

  @override
  __addScreenState createState() => __addScreenState();
}

class __addScreenState extends State<_addScreen> {
  final DbTodo db = DbTodo();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: const Text("Add To Do"),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                CongViec cv = CongViec(
                  tenCV: nameController.text,
                  moTa: contentController.text,
                  trangthai: "Chưa hoàn thành",
                );
                await db
                    .insertCongViec(cv)
                    .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Thêm công việc thành công!")),
                      );
                    })
                    .catchError((error) {
                      print("Lỗi khi thêm công việc: $error");
                    });
                nameController.clear();
                contentController.clear();
              }
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Title"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tiêu đề';
                }
                return null;
              },
              onChanged: (value) {},
            ),

            TextFormField(
              controller: contentController,
              decoration: InputDecoration(labelText: "Content"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập nội dung';
                }
                return null;
              },
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
