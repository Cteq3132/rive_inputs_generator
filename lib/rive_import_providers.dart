import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

final riveFileProvider = StateProvider.autoDispose<RiveFile?>((ref) => null);
