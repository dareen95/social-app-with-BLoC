class UserModel {
  late String name;
  late String email;
  late String phone;
  late String uid;
  late String bio;
  late String image;
  late String cover;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uid,
    required this.image,
    required this.cover,
    required this.bio,
  });
  UserModel.fromMap(Map<String, dynamic>? map) {
    name = map?['name'] ?? '';
    email = map?['email'] ?? '';
    phone = map?['phone'] ?? '';
    uid = map?['uid'] ?? '';
    bio = map?['bio'] ?? '';
    image = map?['image'] ??
        'https://image.freepik.com/free-photo/handsome-young-man-white-t-shirt-cross-arms-chest-smiling-pleased_176420-21607.jpg';
    cover = map?['cover'] ??
        'https://image.freepik.com/free-photo/happy-good-looking-man-glasses-pointing-finger-left_176420-21192.jpg';
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uid': uid,
      'bio': bio,
      'image': image,
      'cover': cover,
    };
  }
}
