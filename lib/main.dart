import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/layout/home_layout/home_layout.dart';
import 'package:social_app/layout/home_layout/home_layout_provider.dart';
import 'package:social_app/modules/auth/auth_provider.dart';
import 'package:social_app/modules/auth/sign_up/sign_up_screen.dart';
import 'package:social_app/modules/auth/login/login_screen.dart';
import 'package:social_app/shared/components/shared_preferences_keys.dart';
import 'package:social_app/shared/local/CachHelper.dart';
import 'package:social_app/shared/network/dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  final homeLayoutProvider = HomeLayoutProvider();

  await Firebase.initializeApp();

  DioHelper.init();
  await CacheHelper.init();

  final uid = CacheHelper.getData(key: uidKey);

  runApp(
    MaterialApp(
      theme: lightTheme,
      initialRoute: uid == null || uid.isEmpty ? signUpRouteName : homeRouteName,
      routes: {
        loginRouteName: (context) => ChangeNotifierProvider.value(value: authProvider, child: LoginScreen()),
        signUpRouteName: (context) => ChangeNotifierProvider.value(value: authProvider, child: SignUpScreen()),
        homeRouteName: (context) => ChangeNotifierProvider.value(value: homeLayoutProvider, child: HomeLayout()),
        // editProfileRouteName: (context) => EditProfileScreen(),
      },
    ),
  );
}

final loginRouteName = '/login';
final signUpRouteName = '/signUp';
final homeRouteName = '/home';
// final editProfileRouteName = '/home/editProfile';
