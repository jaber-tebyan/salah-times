import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:salah_times/db_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  test('getCoordinate returns expected value', () async {
    final db = CitiesDatabase();
    await db.init();
    final co = await db.getCoordinate(
      countryName: "Turkey",
      cityName: "Kocaeli",
    );
    expect(co, isNotNull);
    expect(co!.lat, 40.7625);
    expect(co.lng, 29.9175);
  });
}
