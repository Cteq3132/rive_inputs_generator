import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:rive_inputs_generator/rive_inputs_extractor.dart';

Future<void> downloadDartCode(String dartCode, String baseName) async {
  final downloadName = firstCharToLower('$baseName.dart');

  final bytes = Uint8List.fromList(dartCode.codeUnits);
  // Encode our file in base64
  final base64 = base64Encode(bytes);
  // Create the link with the file
  final anchor =
      AnchorElement(href: 'data:application/octet-stream;base64,$base64')
        ..target = 'blank';
  // add the name
  anchor.download = downloadName;
  // trigger download
  document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  return;
}
