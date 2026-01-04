import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alert.dart';
import 'package:vizinhanca_solidaria/home/presentation/blocs/home_bloc.dart';
import 'package:vizinhanca_solidaria/home/presentation/components/alert_details_widget.dart';

class VizinhacaPage extends StatefulWidget {
  const VizinhacaPage({super.key});

  @override
  State<VizinhacaPage> createState() => _VizinhacaPageState();
}

class _VizinhacaPageState extends State<VizinhacaPage>
    with AutomaticKeepAliveClientMixin {
  late GoogleMapController _controller;
  final Set<Marker> _marcadores = {};

  bool _exibirDetalhes = false;
  Alert? _alertaSelecionado;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeGetAlerts());
  }

  void _fecharDetalhes() {
    setState(() {
      _exibirDetalhes = false;
    });
  }

  _animateMapCamera(Position location) async {
    _controller.animateCamera(CameraUpdate.newLatLng(
      LatLng(location.latitude, location.longitude),
    ));
  }

  _adicionarMarcadores(List<Alert> alertas) {
    _marcadores.clear(); // Limpa marcadores antigos
    for (var alerta in alertas) {
      _marcadores.add(
        Marker(
            markerId: MarkerId(
                alerta.id.toString()), // Use um ID único para cada alerta
            position: LatLng(alerta.lat, alerta.lng),
            infoWindow: InfoWindow(title: alerta.category), // Exemplo de título
            onTap: () {
              setState(() {
                _exibirDetalhes = true;
                _alertaSelecionado = alerta;
              });
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomeLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is HomeGetAlertsSuccess) {
        _adicionarMarcadores(state.alerts);
        return Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(-23.56220300, -46.65474700), // Posição inicial
                zoom: 14.0,
              ),
              onMapCreated: (controller) => {
                _controller = controller,
                _animateMapCamera(state.currentPosition!)
              },
              markers: _marcadores,
            ),
            if (_exibirDetalhes)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: AlertaDetalhesWidget(
                    alerta: _alertaSelecionado!, onClose: _fecharDetalhes),
              )
          ],
        );
      } else if (state is HomeGetAlertsError) {
        return Center(
          child: Text(state.message),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class Location {}
