import 'package:coleta_localizacoes/features/localizacoes/models/localizacao.dart';
import 'package:geolocator/geolocator.dart';

class ServicoLocalizacao {
  Future<void> validarPermissoes() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('GPS desligado. Ative a localização do aparelho.');
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão negada. Habilite nas configurações do aplicativo.',
      );
    }
  }

  Stream<Localizacao> streamPosicoes() {
    final config = AndroidSettings(
      accuracy: LocationAccuracy.high,
      intervalDuration: const Duration(seconds: 20),
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationTitle: 'Coleta ativa',
        notificationText: 'Coletando localização em primeiro plano',
      ),
    );

    return Geolocator.getPositionStream(locationSettings: config).map(
      (p) => Localizacao(
        latitude: p.latitude,
        longitude: p.longitude,
        precisao: p.accuracy,
        instante: p.timestamp,
      ),
    );
  }

  Future<void> abrirConfiguracoes() => Geolocator.openAppSettings();
}
