/// A class to display the given [value] and its associated [distance].
class DistanceAnd<T> {
  /// Create an instance.
  const DistanceAnd({
    required this.value,
    required this.distance,
  });

  /// The thing to use.
  final T value;

  /// The distance between the current location and [value].
  final double distance;

  /// Use the [hashCode] of [value].
  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(final Object other) {
    if (other is DistanceAnd) {
      return value == other.value;
    }
    return super == other;
  }
}
