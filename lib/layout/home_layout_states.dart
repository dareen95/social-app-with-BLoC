abstract class HomeLayoutStates {}

class HomeLayoutInitialState extends HomeLayoutStates {}

class HomeLayoutChangeNavBarItemState extends HomeLayoutStates {}

class HomeLayoutGetUserSuccessState extends HomeLayoutStates {}

class HomeLayoutGetUserLoadingState extends HomeLayoutStates {}

class HomeLayoutGetUserFailState extends HomeLayoutStates {
  final String error;
  HomeLayoutGetUserFailState(this.error);
}
