import 'src/json/route_point.dart';

/// A class to display the given [point] and its associated [distance].
class PointAndDistance {
  /// Create an instance.
  const PointAndDistance({
    required this.point,
    required this.distance,
  });

  /// The point to show.
  final RoutePoint point;

  /// The distance between the current location and [point].
  final double distance;
}
