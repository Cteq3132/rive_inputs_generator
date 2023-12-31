import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github-gist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_inputs_generator/rive_import_providers.dart';

class RiveInputsExtractor extends ConsumerWidget {
  const RiveInputsExtractor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseName = ref.watch(exportedFileNameProvider);
    if (baseName == null || baseName.isEmpty) {
      return const Text('No base name provided');
    }

    final stateMachineInputs = ref.watch(riveStateMachineInputs);
    if (stateMachineInputs == null) {
      return const Text('No state machine inputs found');
    }

    return DartCodeDisplayWidget(
      stateMachineInputs: stateMachineInputs,
      baseName: baseName,
    );
  }
}

class DartCodeDisplayWidget extends StatelessWidget {
  const DartCodeDisplayWidget({
    super.key,
    required this.stateMachineInputs,
    required this.baseName,
  });

  final IList<String> stateMachineInputs;
  final String baseName;

  @override
  Widget build(BuildContext context) {
    final dartCode = generateDartCode(baseName, stateMachineInputs);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: HighlightView(
              dartCode,
              language: 'dart',
              theme: githubGistTheme,
              padding: const EdgeInsets.all(32),
              textStyle: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}

String generateDartCode(String formattedBaseName, IList<String> inputs) {
  String className = _formatInputName(formattedBaseName)[0].toUpperCase() +
      _formatInputName(formattedBaseName).substring(1);

  // Generate the enum entries
  String enumEntries = inputs
      .map((input) => '${_formatInputName(input)}(name: "$input")')
      .join(',\n  ');

  // Generate the Dart code
  return '''
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:rive/rive.dart';

enum _${className}StateMachineInputs {
  $enumEntries;

  const _${className}StateMachineInputs({required this.name});

  final String name;
}

/// Returns the [_${className}StateMachineInputs] for the given inputs.
IMap<String, bool> _get${className}StateMachineInputs(
    // Add the desired inputs as parameters here.
    // Example: required bool isNight
) {
  var states = IMap(const <String, bool>{});

  // Implement the logic to set the desired state based on the inputs.
  for (final state in _${className}StateMachineInputs.values) {
    // Example conditional logic for an input
    // if (state == _${className}StateMachineInputs.isNight) {
    //   states = states.add(state.name, isNight);
    // }
  }

  return states;
}

void set${className}StateMachineInputs(StateMachineController controller) {
  final states = _get${className}StateMachineInputs(
    // Pass the actual input values here.
  );

  for (final input in controller.inputs) {
    if (states.containsKey(input.name) && input.type == SMIType.boolean) {
      input.value = states[input.name];
    }
  }
}
''';
}

/// Formats the input name to be a valid Dart enum entry.
/// Example: "is night" -> "isNight"
/// Example: "isNight" -> "isNight"
/// Example: "is_night" -> "isNight"
/// Example: "is-night" -> "isNight"
/// Example: "is=night" -> "isNight"
String _formatInputName(String str) {
  // If str ends with " ", remove it
  if (str.endsWith(' ')) {
    str = str.substring(0, str.length - 1);
  }
  // Remove all non-alphanumeric characters
  str = str.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' ');
  // Remove all double, triple, etc. spaces
  str = str.replaceAll(RegExp(r' +'), ' ');

  // Split the string into words
  final words = str.split(' ');

  // Capitalize the first letter of each word
  final capitalizedWords = words.map((word) {
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  });

  // Join the words back together, and set the first letter to lowercase
  return firstCharToLower(capitalizedWords.join());
}

String firstCharToLower(String str) {
  if (str.isEmpty) return str;
  return str[0].toLowerCase() + str.substring(1);
}
