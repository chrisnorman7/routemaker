import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/json/app_options.dart';

/// A provider to get the updating position.
final positionStreamProvider = StreamProvider(
  (final ref) => Geolocator.getPositionStream(
    locationSettings: const LocationSettings(),
  ),
);

/// Provide whether or not the location service is enabled.
final locationServiceEnabledProvider =
    FutureProvider((final ref) => Geolocator.isLocationServiceEnabled());

/// The location services permission provider.
final locationServicePermissionsProvider =
    FutureProvider((final ref) => Geolocator.checkPermission());

/// The provider for shared preferences.
final sharedPreferencesProvider = FutureProvider(
  (final ref) => SharedPreferences.getInstance(),
);

/// The app preferences provider.
final appOptionsProvider = FutureProvider((final ref) async {
  final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
  final data = sharedPreferences.getString(AppOptions.preferencesKey);
  if (data == null) {
    return AppOptions(routes: []);
  }
  final json = jsonDecode(data) as Map<String, dynamic>;
  return AppOptions.fromJson(json);
});

/// Save the app options.
Future<void> saveAppOptions(final WidgetRef ref) async {
  final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
  final appOptions = await ref.watch(appOptionsProvider.future);
  await appOptions.save(sharedPreferences);
}
