import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_app/main.dart';
import 'package:social_app/modules/auth/auth_provider.dart';
import 'package:social_app/shared/components/reuseable_components.dart';
import 'package:social_app/shared/styles/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text('REGISTER', style: getTextTheme(context).headline3?.copyWith(color: Colors.black)),
                ),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text('Register now to communicate with friends', style: getTextTheme(context).bodyText1),
                ),
                SizedBox(height: 16),
                defaultFormField(context: context, label: 'Username', inputType: TextInputType.name, controller: _usernameController),
                SizedBox(height: 16),
                defaultFormField(context: context, label: 'Email', inputType: TextInputType.emailAddress, controller: _emailController),
                SizedBox(height: 16),
                defaultFormField(context: context, label: 'Password', inputType: TextInputType.visiblePassword, controller: _passwordController),
                SizedBox(height: 16),
                defaultFormField(context: context, label: 'phone', inputType: TextInputType.phone, controller: _phoneController),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 48,
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, _) => ElevatedButton(
                      child: authProvider.isSignUpButtonLoading ? CircularProgressIndicator() : Text('REGISTER'),
                      onPressed: authProvider.isSignUpButtonLoading
                          ? null
                          : () async {
                              final result = await authProvider.signUpWithEmailAndPassword(
                                username: _usernameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                phone: _phoneController.text.trim(),
                              );

                              if (result == 'success') {
                                navigateToAndRemoveLast(context, homeRouteName);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                              }
                            },
                    ),
                  ),
                ),
                SizedBox(height: 32),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'LOGIN',
                        style: TextStyle(color: defaultColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigateTo(context, loginRouteName);
                          },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
