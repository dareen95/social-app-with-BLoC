import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/layout/home_layout/home_layout.dart';
import 'package:social_app/layout/home_layout/home_layout_provider.dart';
import 'package:social_app/models/auth/social_user_model.dart';
import 'package:social_app/modules/auth/auth_provider.dart';
import 'package:social_app/modules/auth/sign_up/sign_up_screen.dart';
import 'package:social_app/modules/auth/login/login_screen.dart';
import 'package:social_app/modules/chat/chat_provider.dart';
import 'package:social_app/modules/chat/chat_screen.dart';
import 'package:social_app/modules/feed/feed_provider.dart';
import 'package:social_app/modules/new_post/new_post_provider.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/edit_profile/edit_profile_screen.dart';
import 'package:social_app/modules/settings/settings_provider.dart';
import 'package:social_app/modules/users/users_provider.dart';
import 'package:social_app/shared/components/shared_preferences_keys.dart';
import 'package:social_app/shared/local/CachHelper.dart';
import 'package:social_app/shared/network/dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final authProvider = AuthProvider();
final homeLayoutProvider = HomeLayoutProvider();
final settingsProvider = SettingsProvider();
final postProvider = NewPostProvider();
final feedProvider = FeedProvider();
final userProvider = UsersProvider();
final chatProvider = ChatProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  DioHelper.init();
  await CacheHelper.init();

  final uid = CacheHelper.getData(key: uidKey) as String?;

  if (uid != null && uid.isNotEmpty) {
    try {
      FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
        userModel = SocialUserModel.fromMap(value.data()!);
      });
    } catch (e) {}
  }

  runApp(
    MaterialApp(
      theme: lightTheme,
      initialRoute: uid == null || uid.isEmpty ? signUpRouteName : homeRouteName,
      routes: {
        loginRouteName: (context) => ChangeNotifierProvider.value(value: authProvider, child: LoginScreen()),
        signUpRouteName: (context) => ChangeNotifierProvider.value(value: authProvider, child: SignUpScreen()),
        homeRouteName: (context) => MultiProvider(providers: [
              ChangeNotifierProvider.value(value: homeLayoutProvider),
              ChangeNotifierProvider.value(value: settingsProvider),
            ], child: HomeLayout()),
        editProfileRouteName: (context) => ChangeNotifierProvider.value(value: settingsProvider, child: EditProfileScreen()),
        newPostRouteName: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: postProvider),
                ChangeNotifierProvider.value(value: feedProvider),
              ],
              child: NewPostScreen(),
            ),
        chatScreenRouteName: (context) => ChangeNotifierProvider.value(value: chatProvider, child: ChatScreen())
      },
    ),
  );
}

final loginRouteName = '/login';
final signUpRouteName = '/signUp';
final homeRouteName = '/home';
final editProfileRouteName = '/home/editProfile';
final newPostRouteName = '/home/newPost';
final chatScreenRouteName = '/home/chat';