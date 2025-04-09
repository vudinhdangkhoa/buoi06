import 'package:flutter/material.dart';
import 'package:buoi06/Database/db_sanpham.dart';
import 'package:buoi06/model/sanpham.dart';

class Bai3trenlop extends StatelessWidget {
  const Bai3trenlop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bai3Screen();
  }
}

class Bai3Screen extends StatefulWidget {
  const Bai3Screen({Key? key}) : super(key: key);

  @override
  _Bai3ScreenState createState() => _Bai3ScreenState();
}

class _Bai3ScreenState extends State<Bai3Screen> {
  late DBSanPham db;
  late Future<List<Sanpham>> sanphams = Future.value([]);
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController saleController = TextEditingController();
  bool exists = false;
  @override
  void initState() {
    super.initState();
    db = DBSanPham();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    List<Sanpham> sanphamList = await db.getSanPham();
    if (sanphamList.isEmpty) {
      Sanpham sanpham3 = Sanpham(name: "Sản phẩm 3", price: 300.0, sale: 15.0);
      await db.insertSanPham(sanpham3);
      Sanpham sanpham4 = Sanpham(name: "Sản phẩm 4", price: 400.0, sale: 25.0);
      await db.insertSanPham(sanpham4);
      Sanpham sanpham5 = Sanpham(name: "Sản phẩm 5", price: 500.0, sale: 30.0);
      await db.insertSanPham(sanpham5);
      Sanpham sanpham6 = Sanpham(name: "Sản phẩm 6", price: 600.0, sale: 35.0);
      await db.insertSanPham(sanpham6);
      Sanpham sanpham7 = Sanpham(name: "Sản phẩm 7", price: 700.0, sale: 40.0);
      await db.insertSanPham(sanpham7);
      Sanpham sanpham1 = Sanpham(name: "Sản phẩm 1", price: 100.0, sale: 10.0);
      await db.insertSanPham(sanpham1);
      Sanpham sanpham2 = Sanpham(name: "Sản phẩm 2", price: 200.0, sale: 20.0);
      await db.insertSanPham(sanpham2);
    }
    try {
      setState(() {
        sanphams = db.getSanPham();
      });
    } catch (e) {
      print("Lỗi khi tải dữ liệu sản phẩm: $e");
    }
  }

  Future<void> _loadSanPham() async {
    setState(() {
      sanphams = db.getSanPham();
    });
  }

  Future<void> AddSanPham() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thêm sản phẩm"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    onChanged: (value) {},

                    decoration: InputDecoration(labelText: "Tên sản phẩm"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng nhập tên sản phẩm";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: priceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'vui long nhập giá sản phẩm';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Giá sản phẩm"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: saleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'vui long nhập giá khuyến mãi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Giá khuyến mãi"),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                nameController.clear();
                priceController.clear();
                saleController.clear();
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  double price = double.tryParse(priceController.text) ?? 0.0;
                  double sale = double.tryParse(saleController.text) ?? 0.0;
                  Sanpham sp = Sanpham(
                    name: nameController.text,
                    price: price,
                    sale: sale,
                  );
                  await db
                      .insertSanPham(sp)
                      .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Thêm sản phẩm thành công!")),
                        );
                        _loadSanPham();
                        nameController.clear();
                        priceController.clear();
                        saleController.clear();
                        Navigator.pop(context);
                      })
                      .catchError((error) {
                        print("Lỗi khi thêm sản phẩm: $error");
                      });
                }
              },
              child: Text("Thêm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> detailSP(Sanpham sp) async {
    nameController.text = sp.name ?? '';
    priceController.text = sp.price.toString() ?? '';
    saleController.text = sp.sale.toString() ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thêm sản phẩm"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    onChanged: (value) {},

                    decoration: InputDecoration(labelText: "Tên sản phẩm"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng nhập tên sản phẩm";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: priceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'vui long nhập giá sản phẩm';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Giá sản phẩm"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: saleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'vui long nhập giá khuyến mãi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Giá khuyến mãi"),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                nameController.clear();
                priceController.clear();
                saleController.clear();
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  double price = double.tryParse(priceController.text) ?? 0.0;
                  double sale = double.tryParse(saleController.text) ?? 0.0;
                  sp.price = price;
                  sp.sale = sale;
                  sp.name = nameController.text;
                  await db
                      .updateSanPham(sp)
                      .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Cập nhật sản phẩm thành công!"),
                          ),
                        );
                        _loadSanPham();
                        nameController.clear();
                        priceController.clear();
                        saleController.clear();
                        Navigator.pop(context);
                      })
                      .catchError((error) {
                        print("Lỗi khi thêm sản phẩm: $error");
                      });
                }
              },
              child: Text("Cập nhật"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sản Phẩm")),
      body: FutureBuilder<List<Sanpham>>(
        future: sanphams,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có sản phẩm nào."));
          } else {
            List<Sanpham> sanphamList = snapshot.data!;
            return GridView.builder(
              itemCount: sanphamList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 8.0,
              ),
              itemBuilder: (context, index) {
                Sanpham sanpham = sanphamList[index];
                return Card(
                  child: InkWell(
                    child: Column(
                      children: [
                        Text("Tên: ${sanpham.name}"),
                        Text("Giá: ${sanpham.price}"),
                        Text("Giảm giá: ${sanpham.sale}"),
                        Text("Thuế: ${sanpham.getTax()}"),
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                bottom: 5,
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  iconSize: 30,
                                  onPressed: () {
                                    db
                                        .deleteSanPham(sanpham.id!)
                                        .then((value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Xóa sản phẩm thành công!",
                                              ),
                                            ),
                                          );
                                          _loadSanPham();
                                        })
                                        .catchError((error) {
                                          print("Lỗi khi xóa sản phẩm: $error");
                                        });
                                  },
                                ),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 5,
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  iconSize: 30,
                                  onPressed: () {
                                    detailSP(sanpham);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Thông tin sản phẩm"),
                            content: Center(child: Text(sanpham.toString())),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Đóng"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AddSanPham();
          setState(() async {
            sanphams = db.getSanPham();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
