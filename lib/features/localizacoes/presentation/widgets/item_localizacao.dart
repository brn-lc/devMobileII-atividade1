import 'package:flutter/material.dart';
import '../../models/localizacao.dart';

class ItemLocalizacao extends StatelessWidget {
  final Localizacao loc;

  const ItemLocalizacao({super.key, required this.loc});

  @override
  Widget build(BuildContext context) {
    final dataHora = loc.instante.toString().substring(0, 19);
    return ListTile(
      leading: const Icon(Icons.location_on),
      title: Text('Data/Hora: $dataHora'),
      subtitle: Text(
        'Lat: ${loc.latitude.toStringAsFixed(6)} | '
        'Lon: ${loc.longitude.toStringAsFixed(6)}\n'
        'Precisão: ${loc.precisao.toStringAsFixed(1)} m',
      ),
    );
  }
}
