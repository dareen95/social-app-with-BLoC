import 'package:flutter/material.dart';

void navigateTo(context, name, {Object? arguments}) {
  Navigator.of(context).pushNamed(name, arguments: arguments);
}

void navigateToAndRemoveLast(context, name) {
  Navigator.of(context).pushNamedAndRemoveUntil(name, (route) => false);
}

TextTheme getTextTheme(BuildContext context) => Theme.of(context).textTheme;

Widget defaultFormField({
  required BuildContext context,
  required String label,
  required TextInputType inputType,
  required TextEditingController controller,
  void Function()? onSuffixTapped,
  Icon? prefix,
  Icon? suffix,
  bool obscure = false,
  String? Function(String?)? validator,
}) =>
    TextFormField(
      style: getTextTheme(context).bodyText1,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(gapPadding: 8),
        labelText: label,
        prefixIcon: prefix,
        suffixIcon: IconButton(
          icon: Center(child: suffix),
          onPressed: onSuffixTapped,
        ),
      ),
      obscureText: obscure,
      keyboardType: inputType,
      controller: controller,
      validator: validator ??
          (input) {
            if (input?.isEmpty ?? true) {
              return 'input must not be empty';
            }
            return null;
          },
    );
