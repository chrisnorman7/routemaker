import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final currentPosition = _position;
    final provider = ref.watch(positionStreamProvider);
    return Cancel(
      child: SimpleScaffold(
        title: 'Add Point',
        body: provider.when(
          data: (final data) {
            final currentPosition = _position;
            if (currentPosition == null ||
                data.accuracy < currentPosition.accuracy) {
              _position = data;
            }
            return CallbackShortcuts(
              bindings: {
                SingleActivator(
                  LogicalKeyboardKey.keyS,
                  control: useControlKey,
                  meta: useMetaKey,
                ): savePoint
              },
              child: getBody(currentPosition ?? data),
            );
          },
          error: (final error, final stackTrace) => ErrorListView(
            error: error,
            stackTrace: stackTrace,
          ),
          loading: LoadingWidget.new,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (currentPosition == null) {
              showMessage(
                context: context,
                message: 'Please wait for GPS to register coordinates.',
              );
            } else {
              savePoint();
            }
          },
          tooltip: 'Save Point',
          child: saveIcon,
        ),
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
            autofocus: true,
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
          Semantics(
            liveRegion: true,
            child: CopyListTile(
              title: 'Accuracy',
              subtitle: sensibleDistance(position.accuracy),
            ),
          )
        ],
      );

  /// Save the current point.
  void savePoint() {
    final position = _position!;
    Navigator.pop(context);
    widget.onDone(
      RoutePoint(
        name: pointName,
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      ),
    );
  }
}
