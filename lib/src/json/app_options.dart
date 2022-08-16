import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util.dart';
import 'route_point.dart';
import 'stored_route.dart';

part 'app_options.g.dart';

/// The options for the application.
@JsonSerializable()
class AppOptions {
  /// Create an instance.
  AppOptions({
    required this.routes,
    this.vibrateBetweenRoutePoints = true,
  });

  /// Create an instance from a JSON object.
  factory AppOptions.fromJson(final Map<String, dynamic> json) =>
      _$AppOptionsFromJson(json);

  /// The preferences key to use.
  static const preferencesKey = 'app_preferences';

  /// The defined routes.
  List<StoredRoute> routes;

  /// Whether to vibrate between [RoutePoint]s.
  bool vibrateBetweenRoutePoints;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$AppOptionsToJson(this);

  /// Save the options.
  Future<void> save(final SharedPreferences sharedPreferences) async {
    final data = indentedJsonEncoder.convert(toJson());
    await sharedPreferences.setString(preferencesKey, data);
  }
}
