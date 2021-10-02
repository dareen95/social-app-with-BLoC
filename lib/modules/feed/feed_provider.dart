import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/auth/social_user_model.dart';
import 'package:social_app/models/post/comment_model.dart';
import 'package:social_app/models/post/post_model.dart';
import 'package:social_app/modules/settings/settings_provider.dart';
import 'package:social_app/shared/components/constants.dart';

class FeedProvider extends ChangeNotifier {
  List<PostModel> posts = [];
  Future<String> getPosts() async {
    try {
      posts.clear();
      final postsMapped = await FirebaseFirestore.instance.collection('posts').get();
      for (var postMapped in postsMapped.docs) {
        posts.add(PostModel.fromMap(
          postMapped.data(),
          postId: postMapped.id,
          isLiked: await () async {
            return (await postMapped.reference.collection('likes').doc('likes').get()).data()?[uid] ?? false;
          }(),
          likesNum: await () async {
            return (await postMapped.reference.collection('likes').doc('likes').get()).data()?.length ?? 0;
          }(),
        ));
        notifyListeners();
      }
      for (var element in posts) {
        final uid = element.uid;
        final data = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        final model = SocialUserModel.fromMap(data.data() ?? {});
        element.userImage = model.image ?? '';
      }
      notifyListeners();
      return 'success';
    } catch (e, s) {
      print(e);
      print(s);
      return 'error';
    }
  }

  void emptyPosts() {
    posts = [];
    notifyListeners();
  }

  Future<String> likePost(int index) async {
    final post = posts[index];
    try {
      if (!post.isLiked) {
        await FirebaseFirestore.instance.collection('posts').doc(post.postId).collection('likes').doc('likes').update({uid: true});
        post.likesNum++;
      } else {
        final reference = FirebaseFirestore.instance.collection('posts').doc(post.postId).collection('likes').doc('likes');
        final data = (await reference.get()).data();
        data?.remove(uid);
        await reference.set(data ?? {});
        post.likesNum--;
      }
      post.isLiked = !post.isLiked;
      notifyListeners();
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  List<CommentModel> postComments = [];
  Future<String> getComments(String postId) async {
    try {
      postComments = [];
      final commentsMapped = await FirebaseFirestore.instance.collection('comments').doc(postId).collection(postId).get();
      for (var commentMapped in commentsMapped.docs) {
        postComments.add(CommentModel.fromMap(commentMapped.data(), postId));
      }
      for (var element in postComments) {
        final uid = element.uid;
        final data = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        final model = SocialUserModel.fromMap(data.data() ?? {});
        element.userImage = model.image ?? '';
      }
      notifyListeners();
      return 'success';
    } catch (e, s) {
      print(e);
      print(s);
      return e.toString();
    }
  }

  Future<String> createComment({
    required String postId,
    required String text,
  }) async {
    final commentModel = CommentModel(userModel?.name ?? '', text, uid, userModel?.image ?? '', postId);
    try {
      await FirebaseFirestore.instance.collection('comments').doc(postId).collection(postId).add(commentModel.toMap());
      postComments.insert(0, commentModel);
      notifyListeners();
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }
}
