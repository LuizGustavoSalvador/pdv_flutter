// lib/app/core/database/sqlite_connection_factory.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteConnectionFactory {
  // NUNCA mude este nome depois que o app for para produção,
  // ou os usuários perderão seus dados.
  static const databaseName = 'topedindo_pdv_fiscal.db';
  // A versão controla as migrações. Se você adicionar uma nova tabela
  // ou modificar uma existente, você PRECISA incrementar esta versão.
  static const databaseVersion = 1;

  // Usa o padrão de projeto Singleton para garantir que haverá apenas
  // uma instância desta classe (e, portanto, uma única conexão aberta)
  // em todo o aplicativo.
  static SqliteConnectionFactory? _instance;

  Database? _db;

  SqliteConnectionFactory._(); // Construtor privado

  factory SqliteConnectionFactory() {
    _instance ??= SqliteConnectionFactory._();
    return _instance!;
  }

  // A função principal que abre a conexão com o banco.
  Future<Database> openConnection() async {
    if (_db == null) {
      final String databasePath = await getDatabasesPath();
      final String path = join(databasePath, databaseName);

      _db = await openDatabase(
        path,
        version: databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }
    return _db!;
  }

  // Chamado na PRIMEIRA VEZ que o banco é criado.
  // Aqui é onde você define a estrutura inicial do seu banco (suas tabelas).
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE user (
      id INTEGER PRIMARY KEY,
      tenant_id INTEGER,
      pessoa_id INTEGER,
      nome TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      cpf_cnpj TEXT,
      is_admin INTEGER NOT NULL,
      is_suporte INTEGER NOT NULL
    )
  ''');

    // Adicione aqui outros 'CREATE TABLE' para produtos, vendas, etc.
  }

  // Chamado quando você incrementa o databaseVersion.
  // Usado para fazer alterações no banco de um usuário que já
  // tem uma versão antiga do app instalada.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Lógica de migração. Ex: se (oldVersion == 1) { ... adicione a coluna X ... }
  }

  // Fecha a conexão com o banco. Útil quando o app for fechado.
  void closeConnection() {
    _db?.close();
    _db = null;
  }
}
