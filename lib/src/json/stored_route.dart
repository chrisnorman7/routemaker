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
  const StoredRoute({
    required this.name,
    required this.points,
  });

  /// Create an instance from a JSON object.
  factory StoredRoute.fromJson(final Map<String, dynamic> json) =>
      _$StoredRouteFromJson(json);

  /// The name of this route.
  final String name;

  /// The points along this route.
  final List<RoutePoint> points;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$StoredRouteToJson(this);
}
