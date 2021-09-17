class SocialUserModel {
  String? name;
  String? email;
  String? phone;
  String? uid;
  String? bio;
  String? cover;
  String? image;

  SocialUserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uid,
    required this.bio,
    required this.cover,
    required this.image,
  });

  SocialUserModel.fromMap(Map<String, dynamic> jsonMap) {
    name = jsonMap['name'];
    email = jsonMap['email'];
    phone = jsonMap['phone'];
    uid = jsonMap['uId'];
    bio = jsonMap['bio'];
    cover = jsonMap['cover'];
    image = jsonMap['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uid,
      'bio': bio,
      'cover': cover,
      'image': image,
    };
  }
}
