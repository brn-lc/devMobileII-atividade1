import 'dart:async';

import 'package:coleta_localizacoes/features/localizacoes/data/database/repositories/repositorio_localizacoes.dart';
import 'package:coleta_localizacoes/features/localizacoes/data/database/repositories/services/servico_localizacao.dart';
import 'package:coleta_localizacoes/features/localizacoes/models/localizacao.dart';
import 'package:coleta_localizacoes/features/localizacoes/presentation/screens/tela_localizacoes.dart';
import 'package:coleta_localizacoes/features/localizacoes/presentation/screens/tela_mapa.dart';
import 'package:flutter/material.dart';

class TelaColeta extends StatefulWidget {
  const TelaColeta({super.key});

  @override
  State<TelaColeta> createState() => _TelaColetaState();
}

class _TelaColetaState extends State<TelaColeta> {
  final _servico = ServicoLocalizacao();
  final _repo = RepositorioLocalizacoes();

  StreamSubscription<Localizacao>? _sub;
  bool _gravando = false;
  String _status = 'Coleta parada';

  bool get _ativa => _sub != null;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _iniciar() async {
    if (_ativa) return; // Evita assinatura duplicada

    try {
      await _servico.validarPermissoes();
      _sub = _servico.streamPosicoes().listen(
        (loc) async {
          if (_gravando) return; // Evita gravações sobrepostas
          _gravando = true;
          try {
            await _repo.inserir(loc);
            if (mounted) setState(() => _status = 'Última: ${loc.instante}');
          } finally {
            _gravando = false;
          }
        },
        onError: (e) {
          if (mounted) setState(() => _status = 'Erro: $e');
        },
      );
      if (mounted) setState(() => _status = 'Coleta em andamento...');
    } catch (e) {
      if (mounted) setState(() => _status = e.toString());
    }
  }

  Future<void> _parar() async {
    await _sub?.cancel();
    if (mounted) setState(() => _sub = null);
    if (mounted) setState(() => _status = 'Coleta parada');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coleta de Localizações')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_status),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: !_ativa ? _iniciar : null,
              child: const Text('Iniciar coleta'),
            ),
            ElevatedButton(
              onPressed: _ativa ? _parar : null,
              child: const Text('Parar coleta'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TelaLocalizacoes(coletaAtiva: _ativa),
                ),
              ),
              child: const Text('Consultar histórico'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TelaMapa()),
              ),
              child: const Text('Ver mapa'),
            ),
            TextButton(
              onPressed: _servico.abrirConfiguracoes,
              child: const Text('Configurações de permissão'),
            ),
          ],
        ),
      ),
    );
  }
}
