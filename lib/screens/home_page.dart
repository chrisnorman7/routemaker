import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets/copy_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../providers.dart';
import '../util.dart';

/// The home page widget.
class HomePage extends ConsumerWidget {
  /// Create an instance.
  const HomePage({super.key});

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(positionStreamProvider);
    return provider.when(
      data: (final data) =>
          SimpleScaffold(title: 'Routes', body: getBody(data)),
      error: (final error, final stackTrace) =>
          ErrorScreen(error: error, stackTrace: stackTrace),
      loading: LoadingScreen.new,
    );
  }

  /// Get the body widget.
  Widget getBody(final Position position) {
    final longitude = position.longitude;
    final latitude = position.latitude;
    final accuracy = sensibleDistance(position.accuracy);
    return ListView(
      children: [
        CopyListTile(
          title: 'Longitude',
          subtitle: longitude.toString(),
          autofocus: true,
        ),
        CopyListTile(title: 'Latitude', subtitle: latitude.toString()),
        CopyListTile(title: 'Accuracy', subtitle: accuracy)
      ],
    );
  }
}
