import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:rive_inputs_generator/download_rive_inputs.dart';
import 'package:rive_inputs_generator/rive_import_providers.dart';
import 'package:rive_inputs_generator/rive_inputs_extractor.dart';

class RiveImportView extends ConsumerWidget {
  const RiveImportView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Animation Name',
                ),
                onChanged: (value) {
                  ref.read(exportedFileNameProvider.notifier).state = value;
                },
                // initial value
                controller: TextEditingController(
                  text: ref.read(exportedFileNameProvider),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Download button
            ElevatedButton(
              onPressed: () async {
                final baseName = ref.read(exportedFileNameProvider);
                if (baseName == null || baseName.isEmpty) {
                  return;
                }

                final stateMachineInputs = ref.read(riveStateMachineInputs);
                if (stateMachineInputs == null) {
                  return;
                }
                final dartCode = generateDartCode(baseName, stateMachineInputs);

                await downloadDartCode(dartCode, baseName);
              },
              child: const Text('Download Dart Code'),
            ),
          ],
        ),
      ),
    );
  }
}
