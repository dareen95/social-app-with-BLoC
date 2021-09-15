class SocialUserModel {
  final String name;
  final String email;
  final String phone;
  final String uId;
  final String bio;
  final String cover;
  final String image;
  bool isEmailVerified;

  SocialUserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uId,
    required this.bio,
    required this.cover,
    required this.image,
    required this.isEmailVerified,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'bio': bio,
      'cover': cover,
      'image': image,
      'isEmailVerified': isEmailVerified,
    };
  }
}
