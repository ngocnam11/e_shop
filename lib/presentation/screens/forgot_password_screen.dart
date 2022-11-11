import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/enums.dart';
import '../../config/utils.dart';
import '../../data/repositories/repositories.dart';
import '../../logic/cubits/forgot_password/forgot_password_cubit.dart';
import '../router/app_router.dart';
import '../widgets/text_field_input.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.forgotPassword),
      builder: (_) => BlocProvider(
        create: (context) => ForgotPasswordCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: const ForgotPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == Status.error) {
            showSnackBar(
              context,
              state.errorMessage ?? 'Send Email Failure',
            );
          }
          if (state.status == Status.success) {
            showSnackBar(
              context,
              'Please check your email for password reset link',
            );
          }
        },
        child: Padding(
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
              BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                buildWhen: (previous, current) =>
                    previous.email != current.email,
                builder: (context, state) => TextFieldInput(
                  hintText: 'Enter your email address',
                  textInputType: TextInputType.emailAddress,
                  onChanged: (email) =>
                      context.read<ForgotPasswordCubit>().emailChanged(email),
                  onFieldSubmitted: (_) => context
                      .read<ForgotPasswordCubit>()
                      .sendForgotPasswordEmail(),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status ||
                      previous.isValid != current.isValid,
                  builder: (context, state) {
                    return state.status == Status.submitting
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent[400],
                              fixedSize: const Size.fromWidth(double.maxFinite),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            onPressed: state.isValid
                                ? context
                                    .read<ForgotPasswordCubit>()
                                    .sendForgotPasswordEmail
                                : null,
                            child: const Text('Send me password reset link'),
                          );
                  },
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(AppRouter.login),
                  child: const Text('Back to login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
