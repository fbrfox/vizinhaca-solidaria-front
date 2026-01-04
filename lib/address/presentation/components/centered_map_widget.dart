import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CenteredMapWidget extends StatefulWidget {
  const CenteredMapWidget({super.key});

  @override
  State<CenteredMapWidget> createState() => CenteredMapWidgetState();
}

class CenteredMapWidgetState extends State<CenteredMapWidget> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {}; // Conjunto de marcadores
  final LatLng _initialCameraPosition = const LatLng(-23.550520, -46.633308);

  @override
  void initState() {
    super.initState();
    _addMarker(_initialCameraPosition);
  }

  Future<void> _setInitialLocation() async {
    // Verifica e solicita permissões de localização
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        // As permissões foram negadas, lida com o erro
        return;
      }
    }

    // Obtém a posição atual
    geo.Position currentLocation = await geo.Geolocator.getCurrentPosition();

    // Move a câmera para a posição atual
    _mapController.animateCamera(CameraUpdate.newLatLng(
      LatLng(currentLocation.latitude, currentLocation.longitude),
    ));
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('pin'),
          position: position,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _initialCameraPosition,
        zoom: 14.0,
      ),
      myLocationEnabled: true,
      onMapCreated: (controller) {
        _mapController = controller;
        _setInitialLocation();
      },
      markers: _markers, // Adiciona os marcadores ao mapa
      onCameraMove: (CameraPosition position) {
        // Atualiza a posição do pin centralizado quando a câmera se move

        if (mounted) {
          _addMarker(position.target);
        }
      },
    );
  }

  // Método para obter a latitude e longitude do pin
  LatLng getPinLocation() {
    return _markers.first.position; // Retorna a posição do primeiro marcador
  }
}
