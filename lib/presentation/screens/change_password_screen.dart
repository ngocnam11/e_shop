import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/utils.dart';
import '../../data/repositories/repositories.dart';
import '../../logic/cubits/change_password/change_password_cubit.dart';
import '../router/app_router.dart';
import '../widgets/text_field_input.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.changePassword),
      builder: (_) => BlocProvider(
        create: (context) => ChangePasswordCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: ChangePasswordScreen(),
      ),
    );
  }

  final FocusNode _newPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == ChangePasswordStatus.error) {
            showSnackBar(
              context,
              state.errorMessage ?? 'Change Password Failure',
            );
          }
          if (state.status == ChangePasswordStatus.success) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Successful update password'),
                titleTextStyle: Theme.of(context).textTheme.headline5,
                content:
                    const Text('Your password has been Changed. Log in again!'),
              ),
            ).timeout(
              const Duration(seconds: 3),
              onTimeout: () => Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.login,
                (route) => false,
              ),
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: <Widget>[
            Text(
              'Create new password',
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 12),
            Text(
              'Your new password must be different from previous used passwords.',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Text(
              'Current Password',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
              buildWhen: (previous, current) =>
                  previous.currentPassword != current.currentPassword ||
                  previous.hideCurrentPassword != current.hideCurrentPassword,
              builder: (context, state) => TextFieldInput(
                hintText: 'Enter your current password',
                textInputType: TextInputType.text,
                isPass: state.hideCurrentPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    state.hideCurrentPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.black54,
                  ),
                  onPressed:
                      context.read<ChangePasswordCubit>().hideCurrentChanged,
                ),
                onChanged: (password) => context
                    .read<ChangePasswordCubit>()
                    .currentPasswordChanged(password),
                onFieldSubmitted: (_) => _newPasswordFocusNode.requestFocus(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'New Password',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
              buildWhen: (previous, current) =>
                  previous.newPassword != current.newPassword ||
                  previous.hideNewPassword != current.hideNewPassword,
              builder: (context, state) => TextFieldInput(
                focusNode: _newPasswordFocusNode,
                hintText: 'Enter new password',
                textInputType: TextInputType.text,
                isPass: state.hideNewPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    state.hideNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.black54,
                  ),
                  onPressed: context.read<ChangePasswordCubit>().hideNewChanged,
                ),
                onChanged: (password) => context
                    .read<ChangePasswordCubit>()
                    .newPasswordChanged(password),
                onFieldSubmitted: state.isFormValid
                    ? (_) =>
                        context.read<ChangePasswordCubit>().changePassword()
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status ||
                  previous.isFormValid != current.isFormValid,
              builder: (context, state) {
                return state.status == ChangePasswordStatus.submitting
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[400],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: state.isFormValid
                            ? context.read<ChangePasswordCubit>().changePassword
                            : null,
                        child: const Text('Change Password'),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
