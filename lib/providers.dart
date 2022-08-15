import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

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
