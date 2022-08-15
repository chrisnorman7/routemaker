// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoredRoute _$StoredRouteFromJson(Map<String, dynamic> json) => StoredRoute(
      name: json['name'] as String,
      points: (json['points'] as List<dynamic>)
          .map((e) => RoutePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoredRouteToJson(StoredRoute instance) =>
    <String, dynamic>{
      'name': instance.name,
      'points': instance.points,
    };
