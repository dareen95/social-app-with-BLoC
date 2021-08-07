import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_states.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return HomeCubit()..getUserData();
      },
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('News feed'),
            ),
            body: Container(
              width: double.infinity,
              child: HomeCubit.of(context).model != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!(FirebaseAuth.instance.currentUser?.emailVerified ?? false))
                          ElevatedButton(
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
                          )
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          );
        },
      ),
    );
  }
}
