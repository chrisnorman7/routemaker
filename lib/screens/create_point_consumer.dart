import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../providers.dart';
import '../src/json/route_point.dart';
import '../util.dart';
import '../validators.dart';

/// A widget to create a new point.
class CreatePoint extends ConsumerStatefulWidget {
  /// Create an instance.
  const CreatePoint({
    required this.onDone,
    super.key,
  });

  /// The function to call with the new point.
  final ValueChanged<RoutePoint> onDone;

  /// Create state for this widget.
  @override
  CreatePointState createState() => CreatePointState();
}

/// State for [CreatePoint].
class CreatePointState extends ConsumerState<CreatePoint> {
  /// The name of the new point.
  late String pointName;

  /// The latest position.
  Position? _position;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    pointName = 'Untitled Point';
  }

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final provider = ref.watch(positionStreamProvider);
    return SimpleScaffold(
      title: 'Add Point',
      body: provider.when(
        data: (final data) {
          final currentPosition = _position;
          if (currentPosition == null ||
              data.accuracy < currentPosition.accuracy) {
            _position = data;
          }
          return getBody(currentPosition ?? data);
        },
        error: (final error, final stackTrace) => ErrorListView(
          error: error,
          stackTrace: stackTrace,
        ),
        loading: LoadingWidget.new,
      ),
    );
  }

  /// Get the body for this widget.
  Widget getBody(final Position position) => ListView(
        children: [
          TextListTile(
            value: pointName,
            onChanged: (final value) => setState(() {
              pointName = value;
            }),
            header: 'Name',
            validator: (final value) => validateNonEmptyValue(value: value),
          ),
          CopyListTile(
            title: 'Latitude',
            subtitle: position.latitude.toString(),
          ),
          CopyListTile(
            title: 'Longitude',
            subtitle: position.longitude.toString(),
          ),
          CopyListTile(
            title: 'Accuracy',
            subtitle: sensibleDistance(position.accuracy),
          )
        ],
      );
}
