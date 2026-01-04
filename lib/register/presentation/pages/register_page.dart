import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vizinhanca_solidaria/core/di/injection_container.dart';
import 'package:vizinhanca_solidaria/register/presentation/blocs/register_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<RegisterBloc>(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Cadastro'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: BlocListener<RegisterBloc, RegisterState>(
                listener: (context, state) {
              if (state is RegisterSuccess) {
                // Exibe um snackbar de sucesso
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cadastro realizado com sucesso!'),
                  ),
                );
                // Navega para a tela de login
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              } else if (state is RegisterFailure) {
                // Exibe um snackbar de erro
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                  ),
                );
              }
            }, child: BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
              if (state is RegisterLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Center(
                    child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : null,
                          child: _selectedImage == null
                              ? const Icon(Icons.person, size: 60)
                              : null,
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: _pickImage,
                          child: const Text('Selecionar Imagem'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: _usernameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Username',
                                    hintText: 'Input',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite seu username';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Senha',
                                    hintText: 'Input',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite sua senha';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Confirmar Senha',
                                    hintText: 'Input',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, confirme sua senha';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'As senhas não coincidem';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'Input',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite seu email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nome',
                                    hintText: 'Input',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite seu nome';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                    'Ao se cadastrar, você concorda com os termos.'),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (_selectedImage == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Por favor, selecione uma imagem'),
                                        ));
                                      } else {
                                        context.read<RegisterBloc>().add(
                                              RegisterWithEmailAndPassword(
                                                _usernameController.text,
                                                _passwordController.text,
                                                _confirmPasswordController.text,
                                                _emailController.text,
                                                _nameController.text,
                                                _selectedImage,
                                              ),
                                            );
                                      }
                                    }
                                  },
                                  child: const Text('Cadastrar'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
              }
            }))));
  }
}
