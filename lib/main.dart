import 'package:flutter/material.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/auth/login/login_screen.dart';
import 'package:social_app/modules/auth/sign_up/sign_up_screen.dart';
import 'package:social_app/modules/settings/edit_profile/edit_profile_screen.dart';
import 'package:social_app/shared/local/CachHelper.dart';
import 'package:social_app/shared/my_bloc_observer.dart';
import 'package:social_app/shared/network/dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bloc/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp();

  DioHelper.init();
  await CacheHelper.init();

  final uid = CacheHelper.getData(key: 'uid');

  runApp(
    MaterialApp(
      theme: lightTheme,
      initialRoute: uid == null || uid.isEmpty ? loginRouteName : homeRouteName,
      routes: {
        loginRouteName: (context) => LoginScreen(),
        signUpRouteName: (context) => SignUpScreen(),
        homeRouteName: (context) => HomeLayout(),
        editProfileRouteName: (context) => EditProfileScreen(),
      },
    ),
  );
}

final loginRouteName = '/login';
final signUpRouteName = '/signUp';
final homeRouteName = '/home';
final editProfileRouteName = '/home/editProfile';
