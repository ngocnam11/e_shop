import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/enums.dart';
import '../../config/utils.dart';
import '../../data/repositories/repositories.dart';
import '../../logic/blocs/blocs.dart';
import '../../logic/cubits/signup/signup_cubit.dart';
import '../router/app_router.dart';
import '../widgets/text_field_input.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.signup),
      builder: (_) => BlocProvider(
        create: (context) => SignUpCubit(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
        ),
        child: SignupScreen(),
      ),
    );
  }

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.status == Status.error) {
            showSnackBar(
              context,
              state.errorMessage ?? 'SignUp Failure',
            );
          }
          if (state.status == Status.success) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.home,
              (route) => false,
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: <Widget>[
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
              BlocBuilder<SignUpCubit, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.username != current.username,
                builder: (context, state) => TextFieldInput(
                  hintText: 'Enter your username',
                  labelText: 'Full Name',
                  textInputType: TextInputType.text,
                  onChanged: (username) =>
                      context.read<SignUpCubit>().usernameChanged(username),
                  onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<SignUpCubit, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.email != current.email,
                builder: (context, state) => TextFieldInput(
                  focusNode: _emailFocusNode,
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  onChanged: (email) =>
                      context.read<SignUpCubit>().emailChanged(email),
                  onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<SignUpCubit, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.password != current.password ||
                    previous.isObsecure != current.isObsecure,
                builder: (context, state) => TextFieldInput(
                  focusNode: _passwordFocusNode,
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  textInputType: TextInputType.visiblePassword,
                  isPass: state.isObsecure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isObsecure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black54,
                    ),
                    onPressed: context.read<SignUpCubit>().obsecureChanged,
                  ),
                  onChanged: (password) =>
                      context.read<SignUpCubit>().passwordChanged(password),
                  onFieldSubmitted: state.isFormValid
                      ? (_) {
                          context.read<SignUpCubit>().signUpUser();
                          context.read<WishlistBloc>().add(LoadWishlist());
                        }
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              BlocBuilder<SignUpCubit, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status ||
                    previous.isFormValid != current.isFormValid,
                builder: (context, state) {
                  return state.status == Status.submitting
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: state.isFormValid
                              ? () {
                                  context.read<SignUpCubit>().signUpUser();
                                  context
                                      .read<WishlistBloc>()
                                      .add(LoadWishlist());
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent[400],
                            fixedSize: const Size.fromWidth(double.maxFinite),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Register Now'),
                          ),
                        );
                },
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
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(AppRouter.login),
                    child: const Text('Join now'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
