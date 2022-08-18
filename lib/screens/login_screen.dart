import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo_eshop.png',
              width: 300,
            ),
            const Text(
              'Welcome to eShop',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const Text('Please login to start using app.'),
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (checkValue) {
                        setState(() {
                          _rememberMe = checkValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text('Remember me'),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRouter.forgotPassword);
                  },
                  child: const Text('Forgot password?'),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Not a member?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRouter.signup);
                  },
                  child: const Text('Join now'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const <Widget>[
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Or sign in with'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomButton(
                    press: () {},
                    primaryColor: const Color.fromARGB(255, 24, 119, 242),
                    title: 'Facebook',
                    svg: 'assets/svgs/login/facebook_logo.svg',
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: CustomButton(
                    press: () {},
                    primaryColor: Colors.white,
                    title: 'Google',
                    svg: 'assets/svgs/login/google_logo.svg',
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
