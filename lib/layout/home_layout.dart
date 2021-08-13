import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/shared/components/reuseable_components.dart';
import 'home_layout_states.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return HomeLayoutCubit()..getUserData();
      },
      child: BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = HomeLayoutCubit.of(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(cubit.titles[cubit.navBarIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {},
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Chats'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: 'Users'),
                BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
              ],
              onTap: (index) => cubit.changeNavBarIndex(index),
              currentIndex: cubit.navBarIndex,
            ),
            body: Column(
              children: [
                if (!(FirebaseAuth.instance.currentUser?.emailVerified ?? false)) buildVerificationButton(context),
                HomeLayoutCubit.of(context).userModel != null
                    ? Expanded(child: cubit.screens[cubit.navBarIndex])
                    : Expanded(child: Center(child: CircularProgressIndicator())),
              ],
            ),
          );
        },
      ),
    );
  }

  ElevatedButton buildVerificationButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FirebaseAuth.instance.currentUser?.sendEmailVerification().then(
          (value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Check your email')));
          },
        ).catchError(
          (error) {},
        );
      },
      child: Text('SEND EMAIL VERIFICATION'),
    );
  }
}
