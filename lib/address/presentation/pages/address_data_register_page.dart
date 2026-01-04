import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vizinhanca_solidaria/address/domain/entities/create_address_dto.dart';
import 'package:vizinhanca_solidaria/address/presentation/blocs/address_register_bloc.dart';
import 'package:vizinhanca_solidaria/core/di/injection_container.dart';
import 'package:vizinhanca_solidaria/core/ui/preferences.dart';

class AddressDataRegisterPage extends StatefulWidget {
  final LatLng location; // Localização recebida da tela anterior

  const AddressDataRegisterPage({super.key, required this.location});

  @override
  _AddressDataRegisterPageState createState() =>
      _AddressDataRegisterPageState();
}

class _AddressDataRegisterPageState extends State<AddressDataRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddressRegisterBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de Endereço'),
        ),
        body: BlocListener<AddressRegisterBloc, AddressRegisterState>(
          listener: (context, state) async {
            if (state is AddressRegisterSuccess) {
              // Exibe um snackbar de sucesso
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Endereço cadastrado com sucesso!'),
                ),
              );
              final walkthroughSeen = await checkWalkthroughSeen();

              if (walkthroughSeen) {
                // Navegar para o walkthrough
                Navigator.of(context).pushReplacementNamed('/walkthrough');
                // Marcar o walkthrough como visto
                setWalkthroughSeen();
              } else {
                // Navegar para a tela principal
                Navigator.of(context).pushReplacementNamed('/home');
              }
            } else if (state is AddressRegisterFailure) {
              // Exibe um snackbar de erro
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
          child: BlocBuilder<AddressRegisterBloc, AddressRegisterState>(
            builder: (context, state) {
              if (state is AddressRegisterLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                          child: GoogleMap(
                            // Mapa estático com a localização recebida
                            initialCameraPosition: CameraPosition(
                              target: widget.location,
                              zoom: 14.0,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('pin'),
                                position: widget.location,
                              ),
                            },
                            scrollGesturesEnabled:
                                false, // Desabilita a interação com o mapa
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  // ... (campos do formulário: rua, cidade, estado, CEP)
                                  TextFormField(
                                    controller: _streetController,
                                    decoration: const InputDecoration(
                                      labelText: 'Rua com número',
                                      hintText: 'Input',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, digite o nome da rua';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _cityController,
                                    decoration: const InputDecoration(
                                      labelText: 'Cidade',
                                      hintText: 'Input',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, digite o nome da cidade';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _stateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Estado',
                                      hintText: 'Input',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, digite o estado';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _zipCodeController,
                                    decoration: const InputDecoration(
                                      labelText: 'CEP',
                                      hintText: 'Input',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, digite o CEP';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 32),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        // Dispara o evento para o BLoC
                                        context.read<AddressRegisterBloc>().add(
                                              RegisterAddress(
                                                CreateAddressDto(
                                                  street:
                                                      _streetController.text,
                                                  city: _cityController.text,
                                                  state: _stateController.text,
                                                  zipCode:
                                                      _zipCodeController.text,
                                                  latitude:
                                                      widget.location.latitude,
                                                  longitude:
                                                      widget.location.longitude,
                                                ),
                                              ),
                                            );
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
