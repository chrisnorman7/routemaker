import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../src/json/app_options.dart';
import '../src/json/stored_route.dart';

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
    final provider = ref.watch(appOptionsProvider);
    return provider.when(
      data: (final data) => WithKeyboardShortcuts(
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
        child: CallbackShortcuts(
          bindings: {newShortcut: () => createRoute(ref: ref, options: data)},
          child: SimpleScaffold(
            title: 'Routes',
            body: getBody(data),
            floatingActionButton: FloatingActionButton(
              autofocus: data.routes.isEmpty,
              child: addIcon,
              onPressed: () => createRoute(ref: ref, options: data),
            ),
          ),
        ),
      ),
      error: (final error, final stackTrace) => ErrorScreen(
        error: error,
        stackTrace: stackTrace,
      ),
      loading: LoadingScreen.new,
    );
  }

  /// Create a new route, and save the [options].
  Future<void> createRoute({
    required final WidgetRef ref,
    required final AppOptions options,
  }) async {
    options.routes.add(const StoredRoute(name: 'Untitled Route', points: []));
    final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
    await options.save(sharedPreferences);
    setState(() {});
  }

  /// Get the body of this widget.
  Widget getBody(final AppOptions options) {
    final routes = options.routes;
    if (routes.isEmpty) {
      return const CenterText(text: 'There are no routes to show.');
    }
    return BuiltSearchableListView(
      items: routes,
      builder: (final context, final index) {
        final route = routes[index];
        return SearchableListTile(
          searchString: route.name,
          child: CallbackShortcuts(
            bindings: {
              deleteShortcut: () => confirm(
                    context: context,
                    message: 'Really delete the ${route.name} route?',
                    title: 'Confirm Delete',
                    yesCallback: () async {
                      Navigator.pop(context);
                      routes.remove(route);
                      final sharedPreferences =
                          await ref.watch(sharedPreferencesProvider.future);
                      await options.save(sharedPreferences);
                      setState(() {});
                    },
                  )
            },
            child: PushWidgetListTile(
              title: route.name,
              builder: (final context) =>
                  const SimpleScaffold(title: 'Route', body: Placeholder()),
              autofocus: index == 0,
            ),
          ),
        );
      },
    );
  }
}
