import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/models/billboard.dart';

class ExportService {
  Future<void> exportToCSV(List<Billboard> billboards) async {
    List<List<dynamic>> rows = [];
    rows.add([
      'ID',
      'Latitude',
      'Longitude',
      'Description',
      'Type',
      'Dimension',
      'État',
      'Date Ajout'
    ]);

    for (var b in billboards) {
      rows.add([
        b.id,
        b.latitude,
        b.longitude,
        b.description,
        b.type,
        b.dimension,
        b.condition,
        b.dateAdded
      ]);
    }

    String csvData = csv.encode(rows);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/panneaux_maroua.csv');
    await file.writeAsString(csvData);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Export CSV des panneaux de Maroua',
      ),
    );
  }

  Future<void> exportToGeoJSON(List<Billboard> billboards) async {
    Map<String, dynamic> geojson = {
      'type': 'FeatureCollection',
      'features': billboards.map((b) => {
        'type': 'Feature',
        'geometry': {
          'type': 'Point',
          'coordinates': [b.longitude, b.latitude]
        },
        'properties': {
          'id': b.id,
          'description': b.description,
          'type': b.type,
          'dimension': b.dimension,
          'condition': b.condition,
          'dateAdded': b.dateAdded
        }
      }).toList()
    };

    String geojsonData = jsonEncode(geojson);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/panneaux_maroua.geojson');
    await file.writeAsString(geojsonData);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Export GeoJSON des panneaux de Maroua',
      ),
    );
  }
}
