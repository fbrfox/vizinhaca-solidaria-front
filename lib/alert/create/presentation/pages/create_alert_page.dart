import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/entities/category.dart';
import 'package:vizinhanca_solidaria/alert/create/presentation/blocs/create_alert_bloc.dart';

class CreateAlertPage extends StatefulWidget {
  final Category category;
  const CreateAlertPage({super.key, required this.category});

  @override
  State<CreateAlertPage> createState() => _CreateAlertPageState();
}

class _CreateAlertPageState extends State<CreateAlertPage> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Alerta de ${widget.category.name}'),
        ),
        body: BlocListener<CreateAlertBloc, CreateAlertState>(
            listener: (context, state) {
          if (state is CreateAlertError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is CreateAlertSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Alerta criado com sucesso!'),
              ),
            );
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is UnauthorizerFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );

            Navigator.of(context).pushReplacementNamed('/login');
          }
        }, child: BlocBuilder<CreateAlertBloc, CreateAlertState>(
                builder: (context, state) {
          if (state is CreateAlertLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                      radius: 100,
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
                              minLines: 3,
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                labelText: 'Descrição do Alerta',
                                hintText: 'Input',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, digite a descrição do Alerta';
                                } else if (value.length < 20) {
                                  return 'A descrição deve ter no mínimo 20 caracteres';
                                }
                                return null;
                              },
                              maxLines:
                                  null, // Define como null para permitir múltiplas linhas
                              keyboardType: TextInputType.multiline,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Ao cadastrar um alerta, você concorda com os termos de privacidade e de coleta de dados.',
                              style: TextStyle(fontSize: 10),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_selectedImage != null) {
                                    context.read<CreateAlertBloc>().add(
                                          CreateAlert(
                                              _descriptionController.text,
                                              widget.category.id,
                                              _selectedImage!),
                                        );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Por favor, selecione uma imagem'),
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
        })));
  }
}
