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
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Forgot password',
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
            Text(
              'Email',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 6),
            TextFieldInput(
              controller: emailController,
              hintText: 'Enter your email address',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent[400],
                  fixedSize: const Size.fromWidth(double.maxFinite),
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRouter.login);
                },
                child: const Text('Back to login'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
