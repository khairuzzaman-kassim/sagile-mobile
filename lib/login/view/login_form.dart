import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_repository/project_repository.dart';
import 'package:sagile_mobile/login/login.dart';
import 'package:formz/formz.dart';
import 'package:sagile_mobile/project/bloc/project_bloc.dart';

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: state.status.isValidated
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
                child: const Text('Login'),
              );
      },
      listener: (context, state) {
        if (state.status == FormzStatus.submissionSuccess) {
          context
              .read<ProjectBloc>()
              .add(ProjectStatusChanged(ProjectStatus.retrieving));
        }
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_usernameInput_textField'),
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            errorText: state.username.invalid ? 'Invalid Email' : null,
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
          ),
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_passwordInput_textField'),
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            errorText: state.password.invalid ? 'Invalid Password' : null,
            prefixIcon: Icon(Icons.lock_outline_rounded),
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
        );
      },
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Theme(
        data: ThemeData.light(),
        child: Scaffold(
          body: Center(
            child: isSmallScreen
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _Logo(),
                      _FormContent(),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: const [
                        Expanded(child: _Logo()),
                        Expanded(
                          child: Center(child: _FormContent()),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlutterLogo(size: isSmallScreen ? 100 : 200),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "SAGILE Mobile",
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _UsernameInput(),
            _gap(),
            _PasswordInput(),
            _gap(),
            _LoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
