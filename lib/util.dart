import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

/// Th3e names of the cardinal directions.
const directionNames = [
  'North',
  'Northeast',
  'East',
  'Southeast',
  'South',
  'Southwest',
  'West',
  'Northwest',
];

/// Kilometres.
const km = 1000;

/// Return the given distance in [metres] with sensible units.
String sensibleDistance(final double metres) {
  if (metres > km) {
    return '${(metres / km).floor()} km';
  } else {
    return '${metres.floor()} m';
  }
}

/// Format the given [heading] and return a direction name.
String getDirectionName(final double heading) {
  final index = (((heading % 360) < 0 ? heading + 360 : heading) / 45).round() %
      directionNames.length;
  return directionNames[index];
}

/// Make the device vibrate.
void vibrate() => HapticFeedback.heavyImpact();

/// Speak some [text].
Future<void> speak({
  required final WidgetRef ref,
  required final String text,
}) async {
  final tts = ref.watch(ttsProvider);
  return tts.speak(text);
}
