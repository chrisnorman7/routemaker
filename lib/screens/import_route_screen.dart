import 'dart:convert';

import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../src/json/stored_route.dart';

/// A screen for importing a new [StoredRoute].
class ImportRouteScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const ImportRouteScreen({
    required this.onDone,
    super.key,
  });

  /// The function to call with the newly imported route.
  final ValueChanged<StoredRoute> onDone;

  /// Create state.
  @override
  ImportRouteScreenState createState() => ImportRouteScreenState();
}

/// State for [ImportRouteScreen].
class ImportRouteScreenState extends ConsumerState<ImportRouteScreen> {
  /// The form key.
  late final GlobalKey<FormState> formKey;

  /// The controller for the text field.
  late final TextEditingController controller;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey();
    controller = TextEditingController();
  }

  @override
  Widget build(final BuildContext context) => Cancel(
        child: SimpleScaffold(
          title: 'Import Route',
          body: Form(
            key: formKey,
            child: TextFormField(
              autofocus: true,
              autocorrect: false,
              controller: controller,
              decoration: const InputDecoration(
                hintText:
                    'A JSON value probably exported with the share button from '
                    'this app',
                labelText: 'Json',
              ),
              keyboardType: TextInputType.multiline,
              validator: (final value) {
                if (value == null || value.isEmpty) {
                  return 'You must provide a value.';
                }
                try {
                  final jsonValue = jsonDecode(value) as Map<String, dynamic>;
                  StoredRoute.fromJson(jsonValue);
                } on FormatException {
                  return 'Invalid JSON value';
                  // ignore: avoid_catching_errors
                } on TypeError {
                  return 'That does not look like a route';
                }
                return null;
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(context);
                final json =
                    jsonDecode(controller.text) as Map<String, dynamic>;
                final route = StoredRoute.fromJson(json);
                widget.onDone(route);
              } else {}
            },
            tooltip: 'Import Route',
            child: addIcon,
          ),
        ),
      );
}
