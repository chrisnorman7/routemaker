import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';

import 'route_point.dart';

part 'stored_route.g.dart';

/// A route with multiple [points].
///
/// This class would have simply been called `Route`, but unfortunately that
/// name has been taken.
@JsonSerializable()
@JsonSerializable()
class StoredRoute {
  /// Create an instance.
  StoredRoute({
    required this.name,
    required this.points,
  });

  /// Create an instance from a JSON object.
  factory StoredRoute.fromJson(final Map<String, dynamic> json) =>
      _$StoredRouteFromJson(json);

  /// The name of this route.
  String name;

  /// The points along this route.
  final List<RoutePoint> points;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$StoredRouteToJson(this);

  /// Get the distance between the nearest of the [points] of this route, and
  /// the provided [position].
  ///
  /// If [points] is empty, then `null` will be returned.
  double? getDistanceFrom(final Position position) {
    final distances = points
        .map<double>(
          (final e) => Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            e.latitude,
            e.longitude,
          ),
        )
        .toList()
      ..sort();
    if (distances.isEmpty) {
      return null;
    }
    return distances.first;
  }
}
