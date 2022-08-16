import 'package:flutter/material.dart';

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
            const Text(
              'eShop',
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text(
              'Create a new account',
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
            const Text(
                'Please put your infomation below to create a new account for using app.',),
            const SizedBox(height: 30),
            TextFieldInput(
              controller: fullnameController,
              hintText: 'Enter your fullname',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              controller: emailController,
              hintText: 'Enter your email',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              controller: passwordController,
              hintText: 'Enter your password',
              textInputType: TextInputType.visiblePassword,
              isPass: true,
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
              child: const Text('Register Now'),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? '),
                TextButton(
                  onPressed: () {},
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
