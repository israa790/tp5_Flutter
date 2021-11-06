import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tp5v2/models/list_etudiants.dart';
import 'package:tp5v2/models/scol_list.dart';

class dbuse {
  // This will make it easier to update the database
  final int version = 1;
  Database db;
  static final dbuse _dbHelper = dbuse._internal();
  dbuse._internal();
  factory dbuse() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'scol1.db'),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE classes(codClass INTEGER PRIMARY KEY, nomClass TEXT, nbreEtud INTEGER)');
        database.execute(
            'CREATE TABLE etudiants(id INTEGER PRIMARY KEY, codClass INTEGER, nom TEXT, prenom TEXT, datNais TEXT, ' +
                'FOREIGN KEY(codClass) REFERENCES classes(codClass))');
      }, version: version);
    }
    return db;
  }

  Future testDb() async {
    db = await openDb();
    await db.execute('INSERT INTO classes VALUES (1, "DSI31", 27)');
    await db.execute('INSERT INTO classes VALUES (2, "DSI32", 25)');
    await db.execute('INSERT INTO classes VALUES (3, "DSI33", 29)');
    await db.execute(
        'INSERT INTO etudiants VALUES (10, 11, "isra", "belghith", "06/11/1999")');
    await db.execute(
        'INSERT INTO etudiants VALUES (12, 11, "aya", "belghith", "04/08/1991")');
    await db.execute(
        'INSERT INTO etudiants VALUES (13, 13, "imen", "belghith", "16/06/1994")');
    List classes = await db.rawQuery('select * from classes');
    List etudiants = await db.rawQuery('select * from etudiants');
    print(classes[0].toString());
    print(etudiants[0].toString());
  }

  Future<List<ScolList>> getClasses() async {
    final List<Map<String, dynamic>> maps = await db.query('classes');
    return List.generate(maps.length, (i) {
      return ScolList(
        maps[i]['codClass'],
        maps[i]['nomClass'],
        maps[i]['nbreEtud'],
      );
    });
  }

  insertClass(ScolList list) async {
    int id = await this.db.insert(
          'classes',
          list.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<List<ListEtudiants>> getEtudiants(code) async {
    final List<Map<String, dynamic>> maps =
        await db.query('etudiants', where: 'codClass = ?', whereArgs: [code]);
    return List.generate(maps.length, (i) {
      return ListEtudiants(
        maps[i]['id'],
        maps[i]['codClass'],
        maps[i]['nom'],
        maps[i]['prenom'],
        maps[i]['datNais'],
      );
    });
  }

  Future<int> deleteList(ScolList list) async {
    int result = await db
        .delete("etudiants", where: "id = ?", whereArgs: [list.codClass]);
    result = await db
        .delete("classes", where: "codClass = ?", whereArgs: [list.codClass]);
    return result;
  }
}
