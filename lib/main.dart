import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_inputs_generator/rive_import_view.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                flex: 1,
                child: RiveImportView(),
              ),
              // dotted line
              Container(
                height: double.infinity,
                width: 1,
                color: Colors.grey,
              ),
              const Expanded(
                flex: 2,
                child: Center(child: Text('Hello')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
