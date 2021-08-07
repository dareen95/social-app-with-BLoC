import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/models/auth/user_model.dart';
import 'package:social_app/shared/local/CachHelper.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  UserModel? model;

  static HomeCubit of(context) => BlocProvider.of<HomeCubit>(context);

  void getUserData() {
    emit(HomeGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('/users')
        .doc(
          CacheHelper.getData(key: 'uid'),
        )
        .get()
        .then(
      (value) {
        model = UserModel.fromMap(value.data());
        emit(HomeGetUserSuccessState());
      },
    ).catchError(
      (error, stacktrace) {
        print(error);
        print(stacktrace);
        emit(HomeGetUserFailState(error));
      },
    );
  }
}
