import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../models/localizacao.dart';
import 'item_localizacao.dart';

class MapaLocalizacoes extends StatelessWidget {
  final List<Localizacao> localizacoes;
  final MapController controller;
  final TileProvider tileProvider;
  final VoidCallback aoCarregarMapa;

  const MapaLocalizacoes({
    super.key,
    required this.localizacoes,
    required this.controller,
    required this.tileProvider,
    required this.aoCarregarMapa,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: LatLng(
          localizacoes.first.latitude,
          localizacoes.first.longitude,
        ),
        initialZoom: 15,
        onMapReady: aoCarregarMapa,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'br.edu.fatec.coleta_localizacoes',
          tileProvider: tileProvider,
        ),
        MarkerLayer(
          markers: [
            for (int i = 0; i < localizacoes.length; i++)
              Marker(
                point: LatLng(
                  localizacoes[i].latitude,
                  localizacoes[i].longitude,
                ),
                child: GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => ItemLocalizacao(loc: localizacoes[i]),
                  ),
                  child: Icon(
                    Icons.location_pin,
                    // Índice 0 é o mais recente (destacado em vermelho)
                    color: i == 0 ? Colors.red : Colors.blue,
                    size: 36,
                  ),
                ),
              ),
          ],
        ),
        const SimpleAttributionWidget(
          source: Text('OpenStreetMap contributors'),
        ),
      ],
    );
  }
}
