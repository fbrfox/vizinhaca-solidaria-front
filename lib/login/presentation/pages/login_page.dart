import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vizinhanca_solidaria/core/di/injection_container.dart';
import 'package:vizinhanca_solidaria/core/ui/preferences.dart';
import 'package:vizinhanca_solidaria/login/presentation/blocs/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberUser = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginBloc>(),
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginSuccess) {
              // Navegar para a tela principal

              final walkthroughSeen = await checkWalkthroughSeen();

              if (!walkthroughSeen) {
                // Navegar para o walkthrough
                Navigator.of(context).pushReplacementNamed('/walkthrough');
                // Marcar o walkthrough como visto
                setWalkthroughSeen();
              } else {
                // Navegar para a tela principal
                Navigator.of(context).pushReplacementNamed('/home');
              }
            } else if (state is LoginFailure) {
              // Exibir um snackbar com a mensagem de erro
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            } else if (state is LoginSuccessToAddress) {
              // Navegar para a tela de cadastro de endereço
              Navigator.of(context).pushReplacementNamed('/address');
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo.png',
                            height: 200, width: 200),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Login',
                                      hintText: 'Input',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, digite seu login';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                        labelText: 'Senha',
                                        hintText: 'Input',
                                        suffixIcon: IconButton(
                                          // Ícone no final do campo
                                          icon: Icon(_obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText =
                                                  !_obscureText; // Alterna a visibilidade
                                            });
                                          },
                                        )),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, digite sua senha';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberUser,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberUser = value!;
                                          });
                                        },
                                      ),
                                      const Text(
                                        'Relembrar',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),
                                      // TextButton(
                                      //   onPressed: () {
                                      //     // Ação para "esqueceu a senha?"
                                      //   },
                                      //   child: const Text(
                                      //     'esqueceu a senha?',
                                      //     style: TextStyle(
                                      //         color: Colors.blue, fontSize: 12),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<LoginBloc>().add(
                                              LoginWithEmailAndPassword(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                  _rememberUser),
                                            );
                                      }
                                    },
                                    child: const Text('Login'),
                                  ),
                                  // const SizedBox(height: 10),
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     // Ação para "Apple / Google"
                                  //   },
                                  //   child: Text(Platform.isIOS
                                  //       ? 'Login com a Apple'
                                  //       : 'Login com o Google'),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Não tem uma conta?'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/register');
                          },
                          child: const Text('Cadastrar'),
                        ),
                        // const SizedBox(height: 10),
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(),
                        //   onPressed: () {
                        //     // Ação para "Apple / Google"
                        //   },
                        //   child: Text(Platform.isIOS
                        //       ? 'Cadastro com a Apple'
                        //       : 'Cadastro com o Google'),
                        // ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
