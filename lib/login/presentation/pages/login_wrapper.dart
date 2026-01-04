import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vizinhanca_solidaria/login/presentation/blocs/login_bloc.dart';
import 'package:vizinhanca_solidaria/login/presentation/pages/login_page.dart';

class LoginWrapper extends StatelessWidget {
  const LoginWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<LoginBloc>(),
      child: const LoginPage(),
    );
  }
}
