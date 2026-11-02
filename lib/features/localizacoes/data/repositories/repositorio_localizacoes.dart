import '../../models/localizacao.dart';
import '../database/banco_localizacoes.dart';

class RepositorioLocalizacoes {
  Future<void> inserir(Localizacao loc) async {
    final db = await BancoLocalizacoes.abrir();
    await db.insert('localizacoes', loc.toMap());
  }

  Future<List<Localizacao>> consultarUltimas() async {
    final db = await BancoLocalizacoes.abrir();
    final linhas = await db.query(
      'localizacoes',
      orderBy: 'instante DESC',
      limit: 100,
    );
    return linhas.map(Localizacao.fromMap).toList();
  }

  Future<void> excluirTodas() async {
    final db = await BancoLocalizacoes.abrir();
    await db.delete('localizacoes');
  }
}
