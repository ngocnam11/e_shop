import 'package:flutter/material.dart';

import '../widgets/text_field_input.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        automaticallyImplyLeading: false,
        title: TextButton.icon(
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Reset password',
              style: TextStyle(
                fontSize: 42,
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
                  primary: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 20,
                  ),
                ),
                onPressed: () {},
                child: const Text('Send password reset email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
