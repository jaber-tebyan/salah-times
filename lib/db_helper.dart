import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CitiesDatabase {
  Database? database;

  Future<void> init() async {
    var dbDir = await getDatabasesPath();
    Directory(dbDir).create(recursive: true);
    var dbPath = join(dbDir, 'cities.db');
    await deleteDatabase(dbPath);
    ByteData data = await rootBundle.load('assets/db/cities.db');
    var buffer = data.buffer.asUint8List(
      data.offsetInBytes,
      data.buffer.lengthInBytes,
    );
    await File(dbPath).writeAsBytes(buffer);
    database = await openDatabase(dbPath);
  }

  Future<List<String>?> getCities([String? country]) async {
    final db = database;
    if (db == null) {
      throw StateError("Database not initialized");
    }
    final List<Map<String, Object?>> cities;
    if (country == null) {
      cities = await db.query('cities', columns: ['city'], distinct: true);
    } else {
      cities = await db.query(
        'cities',
        columns: ['city'],
        where: 'country = ? COLLATE NOCASE',
        whereArgs: [country],
        distinct: true,
      );
    }
    List<String> result = List.generate(
      cities.length,
      (i) => cities[i]['city'] as String,
    );
    return result;
  }

  Future<List<String>?> getCountries() async {
    final db = database;
    if (db == null) {
      throw StateError("Database not initialized");
    }
    final countries = await db.query(
      'cities',
      columns: ['country'],
      distinct: true,
    );
    List<String> result = List.generate(
      countries.length,
      (i) => countries[i]['country'] as String,
    );
    return result;
  }

  Future<Coordinate?> getCoordinate({
    required String countryName,
    required String cityName,
  }) async {
    final db = database;
    if (db == null) {
      throw StateError("Database not initialized");
    }
    final rows = await db.query(
      'cities',
      columns: ['lat', 'lng'],
      where: 'country = ? COLLATE NOCASE AND city = ? COLLATE NOCASE',
      whereArgs: [countryName, cityName],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first;
    return Coordinate(
      lat: double.parse(row['lat'] as String),
      lng: double.parse(row['lng'] as String),
    );
  }
}

class Coordinate {
  final double lat;
  final double lng;
  Coordinate({required this.lat, required this.lng});
}
