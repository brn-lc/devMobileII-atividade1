import 'package:coleta_localizacoes/features/localizacoes/data/database/repositories/repositorio_localizacoes.dart';
import 'package:coleta_localizacoes/features/localizacoes/data/database/repositories/services/cache_mapa.dart';
import 'package:coleta_localizacoes/features/localizacoes/models/localizacao.dart';
import 'package:coleta_localizacoes/features/localizacoes/presentation/widgets/mapa_localizacoes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  final _repo = RepositorioLocalizacoes();
  final _mapController = MapController();

  List<Localizacao> _lista = [];
  TileProvider? _tileProvider;
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final cache = await CacheMapa.obterTileProvider();
      final dados = await _repo.consultarUltimas();
      if (!mounted) return;
      setState(() {
        _tileProvider = cache;
        _lista = dados;
        _carregando = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _erro = 'Erro: $e';
          _carregando = false;
        });
      }
    }
  }

  void _enquadrar() {
    if (_lista.isEmpty) return;

    // Aguarda o frame atual terminar de desenhar para não travar a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final pontos =
          _lista.map((l) => LatLng(l.latitude, l.longitude)).toList();
      final primeiro = pontos.first;

      // Verifica se há apenas 1 ponto OU se todos os pontos têm a mesma coordenada
      final todosIguais = pontos.every(
        (p) =>
            p.latitude == primeiro.latitude &&
            p.longitude == primeiro.longitude,
      );

      if (todosIguais) {
        _mapController.move(primeiro, 16);
      } else {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: LatLngBounds.fromPoints(pontos),
            padding: const EdgeInsets.all(40),
            maxZoom: 17,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            onPressed: _enquadrar,
            icon: const Icon(Icons.center_focus_strong),
          ),
          IconButton(
            onPressed: _carregar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? Center(child: Text(_erro!))
              : _lista.isEmpty
                  ? const Center(child: Text('Histórico vazio.'))
                  : MapaLocalizacoes(
                      localizacoes: _lista,
                      controller: _mapController,
                      tileProvider: _tileProvider!,
                      aoCarregarMapa: _enquadrar,
                    ),
    );
  }
}
