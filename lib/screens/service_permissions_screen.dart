import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets/center_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../providers.dart';
import 'home_page.dart';

/// A widget to check location service permissions.
class ServicePermissionsScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const ServicePermissionsScreen({super.key});

  /// Create state.
  @override
  ServicePermissionsScreenState createState() =>
      ServicePermissionsScreenState();
}

/// State for [ServicePermissionsScreen].
class ServicePermissionsScreenState
    extends ConsumerState<ServicePermissionsScreen> {
  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final provider = ref.watch(locationServicePermissionsProvider);
    return provider.when(
      data: (final data) {
        if (data == LocationPermission.deniedForever) {
          return const ErrorScreen(
            error: 'This app does not have location access.',
          );
        } else if (data == LocationPermission.denied) {
          requestPermissions();
          return const SimpleScaffold(
            title: 'Requesting Permissions',
            body: CenterText(
              text: 'Requesting location permissions.',
              autofocus: true,
            ),
          );
        } else if (data == LocationPermission.unableToDetermine) {
          return const ErrorScreen(
            error: 'Unable to determine location permissions.',
          );
        } else {
          return const HomePage();
        }
      },
      error: (final error, final stackTrace) => ErrorScreen(
        error: error,
        stackTrace: stackTrace,
      ),
      loading: LoadingScreen.new,
    );
  }

  /// Request permissions.
  Future<void> requestPermissions() async {
    await Geolocator.requestPermission();
    setState(() {
      ref.refresh(locationServicePermissionsProvider);
    });
  }
}
