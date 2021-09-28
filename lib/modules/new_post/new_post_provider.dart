import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:social_app/models/post/post_model.dart';
import 'package:social_app/modules/settings/settings_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class NewPostProvider extends ChangeNotifier {
  //

  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  List<String> postImages = [];
  Future<String> addImages() async {
    final listOfXFiles = await _picker.pickMultiImage() ?? [];
    if (listOfXFiles.isEmpty) return 'cancelled';
    for (var xFile in listOfXFiles) {
      postImages.add(xFile.path);
    }
    notifyListeners();
    return 'success';
  }

  void emptyImages() {
    postImages = [];
    notifyListeners();
  }

  void removeImage(int index) {
    postImages.removeAt(index);
    notifyListeners();
  }

  Future<String> createPost({
    required String dateTime,
    required String text,
    required List<String> hashtags,
  }) async {
    isLoading = true;
    notifyListeners();
    final postImagesLinks = <String>[];
    for (var index = 0; index < postImages.length; index++) {
      final item = postImages[index];
      final firebaseFile = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(File(item));
      postImagesLinks.add(await firebaseFile.ref.getDownloadURL());
    }
    final postModel = PostModel(
      userName: userModel?.name ?? '',
      userImage: userModel?.image ?? '',
      uid: userModel?.uid ?? '',
      dateTime: dateTime,
      text: text,
      hashtags: hashtags,
      images: postImagesLinks,
      postId: '',
    );
    try {
      final result = await FirebaseFirestore.instance.collection('posts').add(postModel.toMap());
      await FirebaseFirestore.instance.collection('posts').doc(result.id).collection('likes').doc('likes').set({});
      isLoading = false;
      notifyListeners();
      return 'success';
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return 'error';
    }
  }
}
