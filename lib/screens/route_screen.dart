import 'dart:math';

import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';

import '../distance_and.dart';
import '../providers.dart';
import '../src/json/route_point.dart';
import '../src/json/stored_route.dart';
import '../util.dart';
import '../validators.dart';
import 'create_point.dart';

/// A screen to display the given [route].
class RouteScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const RouteScreen({
    required this.route,
    super.key,
  });

  /// The route to display.
  final StoredRoute route;

  /// Create state of this widget.
  @override
  RouteScreenState createState() => RouteScreenState();
}

/// State for [RouteScreen].
class RouteScreenState extends ConsumerState<RouteScreen> {
  /// The most recently announced point.
  RoutePoint? _lastAnnouncedPoint;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final provider = ref.watch(positionStreamProvider);
    return Cancel(
      child: CallbackShortcuts(
        bindings: {newShortcut: newPoint},
        child: SimpleScaffold(
          title: widget.route.name,
          body: provider.when(
            data: getBody,
            error: (final error, final stackTrace) => ErrorScreen(
              error: error,
              stackTrace: stackTrace,
            ),
            loading: LoadingScreen.new,
          ),
          actions: [
            IconButton(
              onPressed: () => Share.share(
                indentedJsonEncoder.convert(widget.route.toJson()),
                subject: 'Route JSON',
              ),
              icon: const Icon(
                Icons.share,
                semanticLabel: 'Share JSON',
              ),
            ),
            TextButton(
              onPressed: () => pushWidget(
                context: context,
                builder: (final context) => GetText(
                  onDone: (final value) async {
                    Navigator.pop(context);
                    widget.route.name = value;
                    await saveAppOptions(ref);
                    ref.refresh(appOptionsProvider);
                  },
                  labelText: 'Route Name',
                  text: widget.route.name,
                  title: 'Rename Route',
                  validator: (final value) =>
                      validateNonEmptyValue(value: value),
                ),
              ),
              child: const Text('Rename'),
            )
          ],
          floatingActionButton: FloatingActionButton(
            autofocus: widget.route.points.isEmpty,
            onPressed: newPoint,
            tooltip: 'Add A Route Point',
            child: addIcon,
          ),
        ),
      ),
    );
  }

  /// Display the body for this widget.
  Widget getBody(final Position position) {
    final accuracy = sensibleDistance(position.accuracy);
    final latitude = position.latitude;
    final longitude = position.longitude;
    final points = widget.route.points
        .map<DistanceAnd<RoutePoint>>(
          (final e) => DistanceAnd<RoutePoint>(
            value: e,
            distance: max(
              0,
              Geolocator.distanceBetween(
                    latitude,
                    longitude,
                    e.latitude,
                    e.longitude,
                  ) -
                  position.accuracy,
            ),
          ),
        )
        .toList()
      ..sort(
        (final a, final b) => a.distance.compareTo(b.distance),
      );
    if (points.isEmpty) {
      return const CenterText(text: 'This route has no points.');
    }
    final nearestPoint = points.first;
    if (nearestPoint.distance <= position.accuracy) {
      final lastAnnounced = _lastAnnouncedPoint;
      if (lastAnnounced == null || lastAnnounced != nearestPoint.value) {
        _lastAnnouncedPoint = nearestPoint.value;
        vibrate();
        speak(ref: ref, text: '$accuracy: ${nearestPoint.value.name}');
      }
    } else {
      _lastAnnouncedPoint = null;
    }
    return WithKeyboardShortcuts(
      keyboardShortcuts: const [
        KeyboardShortcut(
          description: 'Delete the currently-selected point.',
          keyName: 'Delete',
        ),
        KeyboardShortcut(
          description: 'Add a new point to this route.',
          keyName: 'N',
          control: true,
        )
      ],
      child: ListView.builder(
        itemBuilder: (final context, final index) {
          final object = points[index];
          final point = object.value;
          final distance = object.distance;
          final bearing = getDirectionName(
            (Geolocator.bearingBetween(
                      latitude,
                      longitude,
                      point.latitude,
                      point.longitude,
                    ) -
                    position.heading) %
                360,
          );
          return CallbackShortcuts(
            bindings: {deleteShortcut: () => deletePoint(point)},
            child: PushWidgetListTile(
              title: object.value.name,
              subtitle: distance == 0
                  ? 'Within $accuracy'
                  : '${sensibleDistance(distance)} $bearing',
              autofocus: index == 0,
              builder: (final context) => GetText(
                onDone: (final value) {
                  Navigator.pop(context);
                  point.name = value;
                  saveAppOptions(ref);
                  setState(() {});
                },
              ),
              onLongPress: () => deletePoint(point),
            ),
          );
        },
        itemCount: points.length,
      ),
    );
  }

  /// Delete the given [point].
  Future<void> deletePoint(final RoutePoint point) => confirm(
        context: context,
        message: 'Really delete the ${point.name} point?',
        title: 'Confirm Delete',
        yesCallback: () async {
          Navigator.pop(context);
          widget.route.points.remove(point);
          await saveAppOptions(ref);
        },
      );

  /// Create a new point.
  Future<void> newPoint() => pushWidget(
        context: context,
        builder: (final context) => CreatePoint(
          onDone: (final value) {
            widget.route.points.add(value);
            saveAppOptions(ref);
            setState(() {});
          },
        ),
      );
}
