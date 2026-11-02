import 'package:coleta_localizacoes/features/localizacoes/data/repositories/repositorio_localizacoes.dart';
import 'package:coleta_localizacoes/features/localizacoes/models/localizacao.dart';
import 'package:coleta_localizacoes/features/localizacoes/presentation/widgets/item_localizacao.dart';
import 'package:flutter/material.dart';

class TelaLocalizacoes extends StatefulWidget {
  final bool coletaAtiva;
  const TelaLocalizacoes({super.key, required this.coletaAtiva});

  @override
  State<TelaLocalizacoes> createState() => _TelaLocalizacoesState();
}

class _TelaLocalizacoesState extends State<TelaLocalizacoes> {
  final _repo = RepositorioLocalizacoes();
  List<Localizacao> _lista = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _atualizar();
  }

  Future<void> _atualizar() async {
    setState(() => _carregando = true);
    try {
      final dados = await _repo.consultarUltimas();
      if (mounted) setState(() => _lista = dados);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _limpar() async {
    final msgColeta = widget.coletaAtiva
        ? ' A coleta está ativa e novos registros continuarão sendo salvos.'
        : '';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar histórico'),
        content: Text('A exclusão é permanente.$msgColeta'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Limpar histórico'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    try {
      await _repo.excluirTodas();
      await _atualizar();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Histórico limpo com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          IconButton(onPressed: _atualizar, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: _limpar, icon: const Icon(Icons.delete)),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _lista.length,
              itemBuilder: (_, i) => ItemLocalizacao(loc: _lista[i]),
            ),
    );
  }
}
