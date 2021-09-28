import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/models/auth/social_user_model.dart';
import 'package:image_picker/image_picker.dart';

SocialUserModel? userModel;

class SettingsProvider extends ChangeNotifier {
  //
  Future<String> getUserData() async {
    try {
      final data = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      userModel = SocialUserModel.fromMap(data.data()!);
      profileImage = userModel?.image ?? '';
      coverImage = userModel?.cover ?? '';
      notifyListeners();
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  final ImagePicker _picker = ImagePicker();
  Future<File?> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  String profileImage = '';
  Future<String> pickProfileImage() async {
    profileImage = (await _pickImage())?.path ?? '';
    notifyListeners();
    if (profileImage.isEmpty) return 'error';
    return 'success';
  }

  String coverImage = '';
  Future<String> pickCoverImage() async {
    coverImage = (await _pickImage())?.path ?? '';
    notifyListeners();
    if (coverImage.isEmpty) return 'error';
    return 'success';
  }

  Future<String> uploadProfileImage(File image) async {
    try {
      if (userModel != null) {
        final firebaseFile = await firebase_storage.FirebaseStorage.instance.ref().child('users/profile_images/${userModel!.uid}').putFile(image);
        profileImage = await firebaseFile.ref.getDownloadURL();
        return 'success';
      }
      return 'error';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> uploadCoverImage(File image) async {
    try {
      if (userModel != null) {
        final firebaseFile = await firebase_storage.FirebaseStorage.instance.ref().child('users/cover_images/${userModel!.uid}').putFile(image);
        coverImage = await firebaseFile.ref.getDownloadURL();
        return 'success';
      }
      return 'error';
    } catch (e) {
      return e.toString();
    }
  }

  bool isPageLoading = false;
  Future<String> updateUser({
    required String name,
    required String bio,
    required String phone,
  }) async {
    try {
      if (userModel == null) throw Exception('usermodel cannot be null');
      isPageLoading = true;
      notifyListeners();
      final willUploadProfileImage = !Uri.parse(profileImage).isAbsolute;
      if (willUploadProfileImage) {
        await uploadProfileImage(File(profileImage));
      }
      final willUploadCoverImage = !Uri.parse(coverImage).isAbsolute;
      if (willUploadCoverImage) {
        await uploadCoverImage(File(coverImage));
      }
      SocialUserModel model = SocialUserModel(
        name: name,
        phone: phone,
        bio: bio,
        email: userModel?.email,
        image: willUploadProfileImage ? profileImage : userModel?.image,
        cover: willUploadCoverImage ? coverImage : userModel?.cover,
        uid: userModel?.uid,
      );
      await FirebaseFirestore.instance.collection('users').doc(userModel?.uid).update(model.toMap());
      await getUserData();
      isPageLoading = false;
      notifyListeners();
      return 'success';
    } catch (e) {
      isPageLoading = false;
      notifyListeners();
      return e.toString();
    }
  }
}
