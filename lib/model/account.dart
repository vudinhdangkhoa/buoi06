class Account {
  int? id;
  String? email;
  String? password;
  Account({this.id, required this.email, required this.password});

  @override
  String toString() {
    // TODO: implement toString
    return 'id: $id \nemail: $email \npassword: $password';
  }

  Map<String, dynamic> ToMap() {
    return {'id': id, 'email': email, 'password': password};
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      email: map['email'],
      password: map['password'],
    );
  }
}
