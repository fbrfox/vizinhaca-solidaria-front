import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vizinhanca_solidaria/home/presentation/blocs/home_bloc.dart';
import 'package:vizinhanca_solidaria/home/presentation/pages/home_page.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<HomeBloc>(),
      child: const HomePage(),
    );
  }
}
