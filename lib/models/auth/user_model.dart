class UserModel {
  late String name;
  late String email;
  late String phone;
  late String uid;

  UserModel(this.name, this.email, this.phone, this.uid);
  UserModel.fromMap(Map<String, dynamic>? map) {
    name = map?['name'] ?? '';
    email = map?['email'] ?? '';
    phone = map?['phone'] ?? '';
    uid = map?['uid'] ?? '';
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uid': uid,
    };
  }
}
