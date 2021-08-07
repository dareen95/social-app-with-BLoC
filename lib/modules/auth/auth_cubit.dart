import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/auth/user_model.dart';
import 'package:social_app/modules/auth/auth_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(LoginInitialState());

  var _isObscure = true;
  get isObscure => _isObscure;
  set isObscure(value) {
    _isObscure = value;
    emit(LoginPasswordObscureState());
  }

  static AuthCubit of(context) => BlocProvider.of(context);

  void signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(SignupLoadingState());
    print('loading');
    var uid = '';
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then(
      (credentials) {
        uid = credentials.user!.uid;
        print(credentials.user!.email);
        print(credentials.user!.uid);
        final userModel = UserModel(name, email, phone, credentials.user!.uid);
        FirebaseFirestore.instance
            .collection('/users')
            .doc(credentials.user!.uid)
            .set(
              userModel.toMap(),
            )
            .then((value) => emit(SignupSuccessfulState()))
            .catchError(
              (e, s) => onRegisterError(e, s, uid),
            );
      },
    ).catchError(
      (e, s) => onRegisterError(e, s, uid),
    );
  }

  FutureOr<Null> onRegisterError(error, stackTrace, String uid) {
    FirebaseFirestore.instance.collection('/users').doc(uid).delete();
    FirebaseAuth.instance.signOut();
    print(error.toString());
    print(stackTrace.toString());
    emit(SignupErrorState());
  }

  void login({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    print('loading');
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then(
      (credentials) {
        emit(LoginSuccessfulState(credentials.user?.uid ?? ''));
      },
    ).catchError(
      (error, stackTrace) {
        print(error.toString());
        print(stackTrace);
        emit(LoginErrorState());
      },
    );
  }
}
