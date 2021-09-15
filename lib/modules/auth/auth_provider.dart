import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/models/auth/social_user_model.dart';
import 'package:social_app/shared/components/shared_preferences_keys.dart';
import 'package:social_app/shared/local/CachHelper.dart';


class AuthProvider extends ChangeNotifier {
  //
  bool isSignUpButtonLoading = false;
  Future<String> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      isSignUpButtonLoading = true;
      notifyListeners();
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final result = await createUser(username: username, email: email, phone: phone, uid: user.user!.uid);
      if (result == 'success') {
        await CacheHelper.saveData(key: uidKey, value: user.user!.uid);
        isSignUpButtonLoading = false;
        notifyListeners();
        return 'success';
      }
      throw Exception('an error occurred with firebase');
    } on FirebaseAuthException catch (e) {
      isSignUpButtonLoading = false;
      notifyListeners();
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      if (e.toString() == 'Exception: an error occurred with firebase') {
        await FirebaseAuth.instance.currentUser?.delete();
      }
      isSignUpButtonLoading = false;
      notifyListeners();
      return e.toString();
    }
    isSignUpButtonLoading = false;
    notifyListeners();
    return 'an error occurred';
  }

  Future<String> createUser({
    required String username,
    required String email,
    required String phone,
    required String uid,
  }) async {
    SocialUserModel model = SocialUserModel(
      name: username,
      email: email,
      phone: phone,
      uId: uid,
      bio: 'write you bio ...',
      cover:
          'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
      image:
          'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
      isEmailVerified: false,
    );

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set(model.toMap());
      return 'success';
    } catch (e) {
      return 'error';
    }
  }

  bool isLoginButtonLoading = false;
  Future<String> loginWithEmailAndPassword({required String email, required String password}) async {
    try {
      isLoginButtonLoading = true;
      notifyListeners();
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      await CacheHelper.saveData(key: uidKey, value: FirebaseAuth.instance.currentUser?.uid);
      isLoginButtonLoading = false;
      notifyListeners();
      return 'success';
    } catch (e) {
      isLoginButtonLoading = false;
      notifyListeners();
      return e.toString();
    }
  }
}
