import 'package:flutter/material.dart';

import '../config/utils.dart';
import '../router/router.dart';
import '../services/auth_services.dart';
import '../widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.signup),
      builder: (_) => const SignupScreen(),
    );
  }

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthServices().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      username: usernameController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (res == 'success') {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.home,
        (route) => false,
      );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/logo_eshop.png',
              width: 280,
            ),
            const Text(
              'Create a new account',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              'Please put your infomation below to create a new account for using app.',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 30),
            TextFieldInput(
              controller: usernameController,
              hintText: 'Enter your username',
              labelText: 'Full Name',
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            TextFieldInput(
              controller: emailController,
              hintText: 'Enter your email',
              labelText: 'Email',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFieldInput(
              controller: passwordController,
              hintText: 'Enter your password',
              labelText: 'Password',
              textInputType: TextInputType.visiblePassword,
              isPass: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: signUpUser,
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent[400],
                fixedSize: const Size.fromWidth(double.maxFinite),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Register Now'),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Already have an account?',
                  style: Theme.of(context).textTheme.headline6,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(AppRouter.login);
                  },
                  child: const Text('Join now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
