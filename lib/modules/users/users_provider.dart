import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:social_app/models/auth/social_user_model.dart';
import 'package:social_app/shared/components/constants.dart';

class UsersProvider extends ChangeNotifier {
  //
  final users = <SocialUserModel>[];
  Future<String> getUsers() async {
    try {
      users.clear();
      final usersDocs = await FirebaseFirestore.instance.collection('users').get();
      usersDocs.docs.forEach((element) {
        print(element.data()['uId']);
        print(uid);
        if (element.data()['uId'] != uid) users.add(SocialUserModel.fromMap(element.data()));
      });
      notifyListeners();
      return 'success';
    } catch (e, s) {
      print(e);
      print(s);
      return 'error';
    }
  }
}
