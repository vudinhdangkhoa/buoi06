import 'package:buoi06/Database/db_taikhoan.dart';
import 'package:buoi06/main.dart';
import 'package:flutter/material.dart';

import 'package:buoi06/model/account.dart';
import 'package:flutter/services.dart';

class Bai5 extends StatefulWidget {
  const Bai5({Key? key}) : super(key: key);

  @override
  _Bai5State createState() => _Bai5State();
}

class _Bai5State extends State<Bai5> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkeyDK = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DB_bai5 db = DB_bai5();
  late Future<List<Account>> _accountList = Future.value([]);

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    List<Account> DStk = await db.getAccount();
    if (DStk.isEmpty) {
      Account acc = Account(email: 'khoavaden@gmail.com', password: 'khoa2412');
      await db.insertAccount(acc);
    }
    try {
      setState(() {
        _accountList = db.getAccount();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), duration: Duration(seconds: 2)),
      );
    }
  }

  Future<void> DangKy() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Đăng ký tài khoản'),
          content: SingleChildScrollView(
            child: Form(
              key: _formkeyDK,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
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
                String email = _emailController.text;
                String password = _passwordController.text;

                if (_formkeyDK.currentState!.validate()) {
                  Account account = Account(email: email, password: password);
                  await db.insertAccount(account).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đăng ký thành công'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context);
                  });
                }
              },
              child: Text('Đăng ký'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text('hủy'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            bool check = await db.checkLogin(email, password);
                            if (_formkey.currentState!.validate() && check) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Menu()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đăng nhập thất bại'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return AlertDialog(
                            //       title: Text('Đăng ký tài khoản'),
                            //       content: SingleChildScrollView(
                            //         child: Form(
                            //           child: Column(
                            //             children: [
                            //               TextFormField(
                            //                 decoration: InputDecoration(
                            //                   labelText: 'Email',
                            //                 ),
                            //                 controller: _emailController,
                            //                 validator: (value) {
                            //                   if (value == null ||
                            //                       value.isEmpty) {
                            //                     return 'Please enter your email';
                            //                   }
                            //                   if (!RegExp(
                            //                     r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                            //                   ).hasMatch(value)) {
                            //                     return 'Please enter a valid email address';
                            //                   }
                            //                   return null;
                            //                 },
                            //               ),
                            //               SizedBox(height: 30),
                            //               TextFormField(
                            //                 decoration: InputDecoration(
                            //                   labelText: 'Password',
                            //                 ),
                            //                 controller: _passwordController,
                            //                 validator: (value) {
                            //                   if (value == null ||
                            //                       value.isEmpty) {
                            //                     return 'Please enter your password';
                            //                   }
                            //                   return null;
                            //                 },
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //       actions: [
                            //         ElevatedButton(
                            //           onPressed: () {
                            //             Navigator.pop(context);
                            //           },
                            //           child: Text('Đăng ký'),
                            //         ),
                            //         ElevatedButton(
                            //           onPressed: () async {
                            //             Navigator.pop(context);
                            //           },
                            //           child: Text('hủy'),
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // );
                            DangKy();
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
