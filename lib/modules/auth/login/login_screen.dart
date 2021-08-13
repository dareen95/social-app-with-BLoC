import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/main.dart';
import 'package:social_app/modules/auth/auth_cubit.dart';
import 'package:social_app/modules/auth/auth_states.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/components/reuseable_components.dart';
import 'package:social_app/shared/local/CachHelper.dart';
import 'package:social_app/shared/styles/colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return AuthCubit();
      },
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (BuildContext context, state) {
          if (state is LoginSuccessfulState) {
            CacheHelper.saveData(key: 'uid', value: state.uid)?.then((value) => navigateToAndRemoveLast(context, 'name'));
            navigateToAndRemoveLast(context, homeRouteName);
          }
        },
        builder: (BuildContext context, Object? state) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: buildTopTitle(context),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'LOGIN',
                                style: getTextTheme(context).headline4?.copyWith(color: Colors.black),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Login now to browse our hot offers',
                                style: getTextTheme(context).subtitle2,
                              ),
                              SizedBox(height: 50),
                              buildEmailForm(context),
                              SizedBox(height: 20),
                              buildPasswordForm(context),
                              SizedBox(height: 20),
                              buildLoginButton(context, state),
                              SizedBox(height: 20.0),
                              buildSignupText(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  RichText buildSignupText(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: getTextTheme(context).bodyText2,
        text: "Don't have an account? ",
        children: <TextSpan>[
          TextSpan(
            text: 'SIGN UP',
            style: getTextTheme(context).bodyText1?.copyWith(color: defaultColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                navigateTo(context, signUpRouteName);
              },
          ),
        ],
      ),
    );
  }

  Container buildLoginButton(BuildContext context, state) {
    return Container(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
        onPressed: state is LoginLoadingState
            ? null
            : () {
                if (formKey.currentState?.validate() ?? false) {
                  AuthCubit.of(context).login(email: emailController.text, password: passwordController.text);
                }
              },
        child: state is LoginLoadingState ? CircularProgressIndicator(color: Colors.white) : Text('LOGIN'),
      ),
    );
  }

  Widget buildPasswordForm(BuildContext context) {
    return defaultFormField(
      context: context,
      label: 'password',
      inputType: TextInputType.visiblePassword,
      prefix: Icon(Icons.lock_outlined),
      obscure: AuthCubit.of(context).isObscure,
      controller: passwordController,
      suffix: Icon(AuthCubit.of(context).isObscure ? Icons.visibility : Icons.visibility_off),
      onSuffixTapped: () {
        AuthCubit.of(context).isObscure = !AuthCubit.of(context).isObscure;
      },
    );
  }

  Widget buildEmailForm(BuildContext context) {
    return defaultFormField(
      context: context,
      label: 'email',
      inputType: TextInputType.emailAddress,
      prefix: Icon(Icons.email_outlined),
      controller: emailController,
      validator: (input) {
        if (RegExp(emailRegex).hasMatch(input ?? '')) {
          return null;
        }
        return 'write a correct email address';
      },
    );
  }

  Stack buildTopTitle(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          child: CustomPaint(
            painter: CurvePainter(),
          ),
        ),
        Positioned(
          bottom: 60,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'Social App',
              textAlign: TextAlign.center,
              style: getTextTheme(context).headline6?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = defaultColor;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
