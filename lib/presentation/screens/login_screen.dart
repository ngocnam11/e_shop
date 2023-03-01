import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/enums.dart';
import '../../config/utils.dart';
import '../../data/repositories/repositories.dart';
import '../../logic/blocs/blocs.dart';
import '../../logic/cubits/login/login_cubit.dart';
import '../router/app_router.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_field_input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.login),
      builder: (_) => BlocProvider(
        create: (context) => LoginCubit(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
        ),
        child: LoginScreen(),
      ),
    );
  }

  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == Status.error) {
            showSnackBar(
              context,
              state.errorMessage ?? 'Login Failure',
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
                'Welcome to eShop',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              Text(
                'Please login to start using app.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (previous, current) =>
                    previous.email != current.email,
                builder: (context, state) => TextFieldInput(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  onChanged: (email) =>
                      context.read<LoginCubit>().emailChanged(email),
                  onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<LoginCubit, LoginState>(
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
                    onPressed: context.read<LoginCubit>().obsecureChanged,
                  ),
                  onChanged: (password) =>
                      context.read<LoginCubit>().passwordChanged(password),
                  onFieldSubmitted: state.isFormValid
                      ? (_) {
                          context
                              .read<LoginCubit>()
                              .logInWithEmailAndPassword();
                          context.read<WishlistBloc>().add(LoadWishlist());
                        }
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BlocBuilder<LoginCubit, LoginState>(
                    buildWhen: (previous, current) =>
                        previous.remember != current.remember,
                    builder: (context, state) => TextButton.icon(
                      onPressed: context.read<LoginCubit>().rememberChanged,
                      icon: Icon(
                        state.remember
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        color: Colors.black54,
                      ),
                      label: Text(
                        'Remember me',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(AppRouter.forgotPassword),
                    child: const Text('Forgot password?'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status ||
                    previous.isFormValid != current.isFormValid,
                builder: (context, state) {
                  return state.status == Status.submitting
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: state.isFormValid
                              ? () {
                                  context
                                      .read<LoginCubit>()
                                      .logInWithEmailAndPassword();
                                  context
                                      .read<WishlistBloc>()
                                      .add(LoadWishlist());
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent[400],
                            fixedSize: const Size.fromWidth(double.maxFinite),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Login'),
                          ),
                        );
                },
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Not a member?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(AppRouter.signup),
                    child: const Text('Join now'),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: <Widget>[
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Or sign in with',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomButton(
                      press: () {},
                      primaryColor: const Color.fromARGB(255, 24, 119, 242),
                      title: 'Facebook',
                      svg: 'assets/svgs/logo/facebook.svg',
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: CustomButton(
                      press: context.read<LoginCubit>().logInWithGoogle,
                      primaryColor: Colors.white,
                      title: 'Google',
                      svg: 'assets/svgs/logo/google.svg',
                      textColor: Colors.black,
                    ),
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
