import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

final riveFileProvider = StateProvider.autoDispose<RiveFile?>((ref) => null);

final riveStateMachineInputs = Provider.autoDispose((ref) {
  final riveFile = ref.watch(riveFileProvider);
  if (riveFile == null) {
    return null;
  }
  final artboard = riveFile.mainArtboard;
  final stateMachine = artboard.stateMachines.firstOrNull;
  if (stateMachine == null) {
    return null;
  }

  return stateMachine.inputs.map((input) => input.name).toIList();
});

final exportedFileNameProvider =
    StateProvider.autoDispose<String?>((ref) => 'Example');
