abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeGetUserSuccessState extends HomeStates {}

class HomeGetUserLoadingState extends HomeStates {}

class HomeGetUserFailState extends HomeStates {
  final String error;
  HomeGetUserFailState(this.error);
}
