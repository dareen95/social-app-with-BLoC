import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:social_app/main.dart';
import 'package:social_app/modules/auth/auth_provider.dart';
import 'package:social_app/shared/components/reuseable_components.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text('LOGIN', style: getTextTheme(context).headline3?.copyWith(color: Colors.black)),
                ),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text('Login now to communicate with friends', style: getTextTheme(context).bodyText1),
                ),
                SizedBox(height: 16),
                defaultFormField(
                  context: context,
                  label: 'email address',
                  inputType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                SizedBox(height: 16),
                defaultFormField(
                  context: context,
                  label: 'password',
                  inputType: TextInputType.visiblePassword,
                  controller: _passwordController,
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 48,
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, _) => ElevatedButton(
                      child: authProvider.isLoginButtonLoading ? CircularProgressIndicator() : Text('LOGIN'),
                      onPressed: authProvider.isLoginButtonLoading
                          ? null
                          : () async {
                              final result = await authProvider.loginWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
