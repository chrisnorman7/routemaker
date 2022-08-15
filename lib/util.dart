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
