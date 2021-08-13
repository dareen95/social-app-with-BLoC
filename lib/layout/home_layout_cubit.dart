import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/models/auth/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/settings/main_settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/local/CachHelper.dart';

class HomeLayoutCubit extends Cubit<HomeLayoutStates> {
  HomeLayoutCubit() : super(HomeLayoutInitialState());

  static HomeLayoutCubit of(context) => BlocProvider.of<HomeLayoutCubit>(context);

  UserModel? userModel;
  void getUserData() {
    emit(HomeLayoutGetUserLoadingState());
    FirebaseFirestore.instance.collection('/users').doc(CacheHelper.getData(key: 'uid')).get().then(
      (value) {
        userModel = UserModel.fromMap(value.data());
        emit(HomeLayoutGetUserSuccessState());
      },
    ).catchError(
      (error, stacktrace) {
        print(error);
        print(stacktrace);
        emit(HomeLayoutGetUserFailState(error));
      },
    );
  }

  int navBarIndex = 0;
  void changeNavBarIndex(int index) {
    navBarIndex = index;
    emit(HomeLayoutChangeNavBarItemState());
  }

  final titles = ['Home', 'Chats', 'Users', 'Settings'];
  final screens = [
    HomeScreen(),
    ChatsScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
}
