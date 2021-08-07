import 'package:dio/dio.dart';

abstract class AuthStates {}

class LoginInitialState extends AuthStates {}

class LoginPasswordObscureState extends AuthStates {}

class LoginLoadingState extends AuthStates {}

class LoginSuccessfulState extends AuthStates {
  final String uid;
  LoginSuccessfulState(this.uid);
}

class LoginErrorState extends AuthStates {}

class SignupLoadingState extends AuthStates {}

class SignupSuccessfulState extends AuthStates {}

class SignupErrorState extends AuthStates {}
