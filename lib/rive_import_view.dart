import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:rive_inputs_generator/rive_import_providers.dart';

class RiveImportView extends ConsumerWidget {
  const RiveImportView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riveFile = ref.watch(riveFileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Import Rive File')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  var fileBytes = result.files.single.bytes;
                  if (fileBytes == null) {
                    return;
                  }
                  final byteData = ByteData.view(fileBytes.buffer);
                  var riveFile = RiveFile.import(byteData);
                  ref.read(riveFileProvider.notifier).state = riveFile;
                }
              },
              child: const Text('Select Rive File'),
            ),
            // Implement drag and drop widget here if needed
            if (riveFile != null)
              const Text('File selected!')
            else
              const Text('No file selected')
          ],
        ),
      ),
    );
  }
}
