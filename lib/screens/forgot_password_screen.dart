import 'package:flutter/material.dart';

import '../config/utils.dart';
import '../router/router.dart';
import '../services/auth_services.dart';
import '../widgets/text_field_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.forgotPassword),
      builder: (_) => const ForgotPasswordScreen(),
    );
  }

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  bool _isLoading = false;

  void sendPasswordReset() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthServices().sendForgotPasswordEmail(
      toEmail: emailController.text,
    );

    if (!mounted) return;

    if (res == 'success') {
      showSnackBar(context, 'Please check your email for password reset link');
    } else {
      showSnackBar(context, res);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Reset password',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please enter your email below to receive your password reset instructions',
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.clip,
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              controller: emailController,
              hintText: 'Enter your email address',
              labelText: 'Email address',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent[400],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 10,
                  ),
                ),
                onPressed: sendPasswordReset,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text('Send me password reset link'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
