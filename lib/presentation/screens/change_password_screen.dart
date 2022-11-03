import 'package:flutter/material.dart';

import '../../config/utils.dart';
import '../../services/auth_services.dart';
import '../router/app_router.dart';
import '../widgets/text_field_input.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.changePassword),
      builder: (_) => const ChangePasswordScreen(),
    );
  }

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isOldPasswordObscure = true;
  bool _isNewPasswordObscure = true;

  void changePassword() async {
    String resUpdate = await AuthServices().changeUserPassword(
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (!mounted) return;

    if (resUpdate != 'success') {
      showSnackBar(context, resUpdate);
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Successful update password'),
          titleTextStyle: Theme.of(context).textTheme.headline5,
          content: const Text('Your password has been Changed. Log in again!'),
        ),
      ).timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.login,
            (route) => false,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: <Widget>[
          Text(
            'Create new password',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 12),
          Text(
            'Your new password must be different from previous used passwords.',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Text(
            'Current Password',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          TextFieldInput(
            controller: _oldPasswordController,
            hintText: 'Enter your current password',
            textInputType: TextInputType.text,
            isPass: _isOldPasswordObscure,
            suffixIcon: IconButton(
              icon: Icon(
                _isOldPasswordObscure ? Icons.visibility : Icons.visibility_off,
                color: Colors.black54,
              ),
              onPressed: () {
                setState(() {
                  _isOldPasswordObscure = !_isOldPasswordObscure;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'New Password',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          TextFieldInput(
            controller: _newPasswordController,
            hintText: 'Enter new password',
            textInputType: TextInputType.text,
            isPass: _isNewPasswordObscure,
            suffixIcon: IconButton(
              icon: Icon(
                _isNewPasswordObscure ? Icons.visibility : Icons.visibility_off,
                color: Colors.black54,
              ),
              onPressed: () {
                setState(() {
                  _isNewPasswordObscure = !_isNewPasswordObscure;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[400],
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: changePassword,
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }
}
