import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class AppDatabase {
  static Database? _database;

  /// Obtener instancia de la base de datos
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'catmanager.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE funds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        balance REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        description TEXT
      )
    ''');
  }

  // ───────── CRUD TRANSACTIONS ─────────

  static Future<void> insertTransaction(TransactionModel tx) async {
    final db = await database;
    await db.insert('transactions', tx.toMap());
  }

  static Future<List<TransactionModel>> getTransactionsByDate(String date) async {
    final db = await database;
    final result = await db.query(
      'transactions',
      where: 'date = ?',
      whereArgs: [date],
    );

    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  static Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
// Update transaction
  static Future<void> updateTransaction(TransactionModel tx) async {
    final db = await database;
    await db.update(
      'transactions',
      tx.toMap(),
      where: 'id = ?',
      whereArgs: [tx.id],
    );
  }
  static Future<void> insertDefaultFunds() async {
  final db = await database;

  final funds = [
    'Ahorro',
    'Gastos fijos',
    'Gastos variables',
    'Emergencia',
  ];

  for (final fund in funds) {
    await db.insert(
      'funds',
      {
        'name': fund,
        'balance': 0.0,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}

// ───────── CRUD FUNDS ─────────
  static Future<void> addToFund(String fundName, double amount) async {
  final db = await database;

  await db.rawUpdate(
    '''
    UPDATE funds
    SET balance = balance + ?
    WHERE name = ?
    ''',
    [amount, fundName],
  );
}
  
}
