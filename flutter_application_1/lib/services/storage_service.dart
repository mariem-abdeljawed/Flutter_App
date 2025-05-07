import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart'; // Utilisé sur mobile
import 'dart:io'; // Utilisé sur mobile

Future<void> saveData() async {
  if (kIsWeb) {
    // Affiche une alerte ou adapte le comportement pour le web
    print("Web version does not support path_provider.");
    return;
  }

  // Code pour enregistrer les données, qui ne sera exécuté que sur mobile
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/data.txt');
  await file.writeAsString('Hello Flutter!');
}
