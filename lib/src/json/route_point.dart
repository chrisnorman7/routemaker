import 'package:json_annotation/json_annotation.dart';

part 'route_point.g.dart';

/// A point on a route.
@JsonSerializable()
class RoutePoint {
  /// Create an instance.
  RoutePoint({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  /// Create an instance from a JSON object.
  factory RoutePoint.fromJson(final Map<String, dynamic> json) =>
      _$RoutePointFromJson(json);

  /// The name of this point.
  String name;

  /// The latitude coordinate of this point.
  final double latitude;

  /// THe longitude coordinate of this point.
  final double longitude;

  /// The accuracy of this point.
  final double accuracy;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$RoutePointToJson(this);
}
