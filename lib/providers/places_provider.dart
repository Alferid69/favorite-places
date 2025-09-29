import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  try {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, name TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
        );
      },
      version: 1,
    );
    return db;
  } catch (e) {
    print('Something went terribly wrong ln 24');
    print('error: $e');
    throw Exception('Failed to open database: $e');
  }
}

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  Future<void> getPlaces() async {
    try {
      final db = await _getDatabase();
      final data = await db.query('user_places');

      final places = data
          .map(
            (row) => Place(
              id: row['id'] as String,
              name: row['name'] as String,
              image: File(row['image'] as String),
              location: PlaceLocation(
                latitute: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String,
              ),
            ),
          )
          .toList();

      state = places;
    } catch (e) {
      print('Something went terribly wrong ln 55');
      print('error: $e');
    }
  }

  void addNewPlace({
    required String name,
    required File image,
    required PlaceLocation location,
  }) async {
    try {
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final filename = path.basename(image.path);
      final copiedImage = await image.copy('${appDir.path}/$filename');

      final newPlace = Place(
        name: name,
        image: copiedImage,
        location: location,
      );

      final db = await _getDatabase();
      db.insert('user_places', {
        'id': newPlace.id,
        'name': newPlace.name,
        'image': newPlace.image.path,
        'lat': newPlace.location.latitute,
        'lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      });

      print('subfuckinmitted the data');

      state = [newPlace, ...state];
    } catch (e) {
      print('Something went terribly wrong ln 91');
      print('error: $e');
    }
  }
}

final placesProvider = StateNotifierProvider((ref) {
  return PlacesNotifier();
});
