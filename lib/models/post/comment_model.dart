class CommentModel {
  late String name;
  late String text;
  late String uid;
  late String userImage;
  late String postId;

  CommentModel(this.name, this.text, this.uid, this.userImage, this.postId);
   
  CommentModel.fromMap(Map<String, dynamic> map, this.postId) {
    name = map['name'];
    text = map['text'];
    uid = map['uid'];
    userImage= map['userImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'text': text,
      'uid': uid,
      'userImage': userImage,
    };
  }
}