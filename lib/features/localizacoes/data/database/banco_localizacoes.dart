import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoLocalizacoes {
  static Database? _db;

  static Future<Database> abrir() async {
    // Reutiliza a conexão se já estiver aberta
    if (_db != null && _db!.isOpen) return _db!;

    final caminho = join(await getDatabasesPath(), 'localizacoes.db');

    // Se falhar, lança erro e _db continua null (permitindo nova tentativa depois)
    _db = await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE localizacoes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          precisao REAL NOT NULL,
          instante TEXT NOT NULL
        )
      '''),
    );
    return _db!;
  }
}
