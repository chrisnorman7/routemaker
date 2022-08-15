// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppOptions _$AppOptionsFromJson(Map<String, dynamic> json) => AppOptions(
      routes: (json['routes'] as List<dynamic>)
          .map((e) => StoredRoute.fromJson(e as Map<String, dynamic>))
          .toList(),
      vibrateBetweenRoutePoints:
          json['vibrateBetweenRoutePoints'] as bool? ?? true,
    );

Map<String, dynamic> _$AppOptionsToJson(AppOptions instance) =>
    <String, dynamic>{
      'routes': instance.routes,
      'vibrateBetweenRoutePoints': instance.vibrateBetweenRoutePoints,
    };
