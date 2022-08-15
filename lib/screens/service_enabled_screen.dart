import 'package:backstreets_widgets/screens/error_screen.dart';
import 'package:backstreets_widgets/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'service_permissions_screen.dart';

/// A widget that checks if the location service is enabled.
class ServiceEnabledScreen extends ConsumerWidget {
  /// Create an instance.
  const ServiceEnabledScreen({super.key});

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(locationServiceEnabledProvider);
    return provider.when(
      data: (final data) {
        if (data) {
          return const ServicePermissionsScreen();
        } else {
          return const ErrorScreen(
            error: 'The location service is disabled.',
          );
        }
      },
      error: (final error, final stackTrace) => ErrorScreen(
        error: error,
        stackTrace: stackTrace,
      ),
      loading: LoadingScreen.new,
    );
  }
}
