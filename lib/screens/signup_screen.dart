import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/text_field_input.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo_eshop.png',
              width: 300,
            ),
            const Text(
              'Create a new account',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Please put your infomation below to create a new account for using app.',
            ),
            const SizedBox(height: 30),
            TextFieldInput(
              controller: fullnameController,
              hintText: 'Enter your fullname',
              labelText: 'Full Name',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              controller: emailController,
              hintText: 'Enter your email',
              labelText: 'Email',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              controller: passwordController,
              hintText: 'Enter your password',
              labelText: 'Password',
              textInputType: TextInputType.visiblePassword,
              isPass: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRouter.home);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent[400],
                padding: const EdgeInsets.symmetric(
                  horizontal: 90,
                  vertical: 20,
                ),
              ),
              child: const Text('Register Now'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Already have an account? '),
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
