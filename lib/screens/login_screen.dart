import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/text_field_input.dart';
import '../screens/screens.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              'eShop',
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text(
              'Welcome to eShop',
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
            const Text('Please login to start using app.'),
            const SizedBox(height: 30),
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
            TextButton(
              onPressed: () {},
              child: const Text('Forgot password?'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 90,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not a member?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      SignupScreen.routeName,
                      (route) => false,
                    );
                  },
                  child: const Text('Join now'),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              children: const [
                Expanded(
                    child: Divider(
                  height: 10,
                )),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text('Or sign in with'),
                ),
                Expanded(
                    child: Divider(
                  height: 10,
                )),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    press: () {},
                    primaryColor: const Color.fromARGB(255, 24, 119, 242),
                    title: 'Facebook',
                    svg: 'assets/svgs/facebook_logo.svg',
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: CustomButton(
                    press: () {},
                    primaryColor: Colors.white,
                    title: 'Google',
                    svg: 'assets/svgs/google_logo.svg',
                    textColor: Colors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
