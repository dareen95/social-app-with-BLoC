class PostModel {
  late String userName;
  late String userImage;
  late String uid;
  late String dateTime;
  late String text;
  late List<String> hashtags;
  late List<String> images;
  late String postId;
  late bool isLiked;
  late int likesNum;

  PostModel({
    required this.userName,
    required this.userImage,
    required this.uid,
    required this.dateTime,
    required this.text,
    required this.hashtags,
    required this.images,
    required this.postId,
    this.isLiked = false,
    this.likesNum = 0,
  });

  PostModel.fromMap(Map<String, dynamic> map, {required this.postId, this.isLiked = false, this.likesNum = 0}) {
    userName = map['name'] ?? '';
    userImage = map['userImage'] ?? '';
    uid = map['uid'] ?? '';
    dateTime = map['dateTime'] ?? '';
    text = map['text'] ?? '';
    hashtags = (map['hashtags'] as List<dynamic>).map((e) => e.toString()).toList();
    images = (map['images'] as List<dynamic>).map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toMap() {
    return {'name': userName, 'userImage': userImage, 'uid': uid, 'dateTime': dateTime, 'text': text, 'hashtags': hashtags, 'images': images};
  }
}
