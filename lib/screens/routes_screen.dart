import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../distance_and.dart';
import '../providers.dart';
import '../src/json/app_options.dart';
import '../src/json/stored_route.dart';
import '../util.dart';
import 'import_route_screen.dart';
import 'route_screen.dart';

/// A screen to show all the loaded routes.
class RoutesScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const RoutesScreen({super.key});

  /// Create state.
  @override
  RoutesScreenState createState() => RoutesScreenState();
}

/// State for =[RoutesScreen].
class RoutesScreenState extends ConsumerState<RoutesScreen> {
  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final optionsProvider = ref.watch(appOptionsProvider);
    final positionProvider = ref.watch(positionStreamProvider);
    return WithKeyboardShortcuts(
      keyboardShortcuts: const [
        KeyboardShortcut(
          description: 'Create a new route.',
          keyName: 'N',
          control: true,
        ),
        KeyboardShortcut(
          description: 'Delete the currently selected route.',
          keyName: 'Delete',
        )
      ],
      child: optionsProvider.when(
        data: (final options) => SimpleScaffold(
          title: 'Routes',
          body: CallbackShortcuts(
            bindings: {
              newShortcut: () => newRoute(options),
              SingleActivator(
                LogicalKeyboardKey.keyI,
                control: useControlKey,
                meta: useMetaKey,
              ): () => importRoute(options)
            },
            child: positionProvider.when(
              data: (final position) => getBody(
                currentPosition: position,
                options: options,
              ),
              error: (final error, final stackTrace) => ErrorListView(
                error: error,
                stackTrace: stackTrace,
              ),
              loading: LoadingWidget.new,
            ),
          ),
          floatingActionButton: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => importRoute(options),
                icon: const Icon(
                  Icons.import_export,
                  semanticLabel: 'Import Route',
                ),
              ),
              IconButton(
                onPressed: () => newRoute(options),
                icon: const Icon(
                  Icons.add,
                  semanticLabel: 'Add Route',
                ),
              ),
            ],
          ),
        ),
        error: (final error, final stackTrace) => ErrorScreen(
          error: error,
          stackTrace: stackTrace,
        ),
        loading: LoadingScreen.new,
      ),
    );
  }

  /// Create a new route, and save the [options].
  Future<void> newRoute(final AppOptions options) async {
    final route = StoredRoute(name: 'Untitled Route', points: []);
    options.routes.add(route);
    await saveAppOptions(ref);
    await pushWidget(
      context: context,
      builder: (final context) => RouteScreen(route: route),
    );
    setState(() {});
  }

  /// Import a new route.
  Future<void> importRoute(final AppOptions options) => pushWidget(
        context: context,
        builder: (final context) => ImportRouteScreen(
          onDone: (final value) async {
            options.routes.add(value);
            await saveAppOptions(ref);
            setState(() {});
          },
        ),
      );

  /// Get the body of this widget.
  Widget getBody({
    required final Position currentPosition,
    required final AppOptions options,
  }) {
    final routes = options.routes
        .map<DistanceAnd<StoredRoute>>(
          (final e) => DistanceAnd(
            value: e,
            distance: e.getDistanceFrom(currentPosition) ?? 0.0,
          ),
        )
        .toList()
      ..sort(
        (final a, final b) => a.distance.compareTo(b.distance),
      );
    if (routes.isEmpty) {
      return const CenterText(
        text: 'There are no routes to show.',
        autofocus: true,
      );
    }
    return BuiltSearchableListView(
      items: routes,
      builder: (final context, final index) {
        final object = routes[index];
        final route = object.value;
        return SearchableListTile(
          searchString: route.name,
          child: CallbackShortcuts(
            bindings: {
              deleteShortcut: () => deleteRoute(options: options, route: route)
            },
            child: PushWidgetListTile(
              title: route.name,
              subtitle: getDistance(
                distance: object.distance,
                accuracy: currentPosition.accuracy,
              ),
              builder: (final context) => RouteScreen(route: route),
              autofocus: index == 0,
              onLongPress: () => deleteRoute(options: options, route: route),
            ),
          ),
        );
      },
    );
  }

  /// Delete the given [route] from the [options].
  Future<void> deleteRoute({
    required final AppOptions options,
    required final StoredRoute route,
  }) =>
      confirm(
        context: context,
        message: 'Really delete the ${route.name} route?',
        title: 'Confirm Delete',
        yesCallback: () async {
          Navigator.pop(context);
          options.routes.remove(route);
          await saveAppOptions(ref);
          setState(() {});
        },
      );
}
