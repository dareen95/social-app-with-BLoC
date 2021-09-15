import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feed/feed_screen.dart';
import 'package:social_app/modules/settings/main_settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';

class HomeLayoutProvider extends ChangeNotifier {
  int currentIndex = 0;

  final screens = [FeedScreen(), ChatsScreen(), UsersScreen(), SettingsScreen()];
  final titles = ['feed', 'chats', 'users', 'settings'];

  bool isLoading = false;
  bool isEmailVerified = true;
  Future<void> checkEmailVerified() async {
    isLoading = true;
    notifyListeners();
    await FirebaseAuth.instance.currentUser!.reload();
    isLoading = false;
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    notifyListeners();
  }

  final items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'feed'),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chats'),
    BottomNavigationBarItem(icon: Icon(Icons.people), label: 'users'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings'),
  ];

  void changeBottomNavIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<String> verifyEmailAddress() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }
}
