import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vizinhanca_solidaria/address/presentation/components/centered_map_widget.dart';

class AddressRegisterPage extends StatefulWidget {
  const AddressRegisterPage({super.key});

  @override
  State<AddressRegisterPage> createState() => _AddressRegisterPageState();
}

class _AddressRegisterPageState extends State<AddressRegisterPage> {
  final mapaKey = GlobalKey<CenteredMapWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Endereço'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: CenteredMapWidget(
                key: mapaKey,
              ),
            ),
            const SizedBox(height: 20),
            // ... outros campos do formulário (TextField, etc.)
            ElevatedButton(
              onPressed: () {
                LatLng location = mapaKey.currentState!.getPinLocation();
                Navigator.pushNamed(
                  context,
                  '/addressRegister',
                  arguments: location, // Passa a localização como argumento
                );
              },
              child: const Text('Salvar Endereço'),
            ),
          ],
        ),
      ),
    );
  }
}
