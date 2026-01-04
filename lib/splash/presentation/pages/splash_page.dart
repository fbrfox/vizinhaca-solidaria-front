import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vizinhanca_solidaria/core/di/injection_container.dart';
import 'package:vizinhanca_solidaria/login/presentation/pages/home_wrapper.dart';
import 'package:vizinhanca_solidaria/login/presentation/pages/login_wrapper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FlutterSecureStorage storage = sl.get();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      // Defina o tempo de duração do splash
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    String rememberMe = await storage.read(key: 'remember') ??
        'false'; // Valor padrão 'false' se for nulo

    bool remember = rememberMe.toLowerCase() == 'true';

    if (remember) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeWrapper()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginWrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png'), // Substitua pelo seu logo
      ),
    );
  }
}
