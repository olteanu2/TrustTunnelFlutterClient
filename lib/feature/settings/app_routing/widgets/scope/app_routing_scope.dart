import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:trusttunnel/common/controller/widget/state_consumer.dart';
import 'package:trusttunnel/common/error/model/presentation_exception.dart';
import 'package:trusttunnel/common/extensions/context_extensions.dart';
import 'package:trusttunnel/data/model/app_routing_settings.dart';
import 'package:trusttunnel/feature/settings/app_routing/controller/app_routing_controller.dart';
import 'package:trusttunnel/feature/settings/app_routing/controller/app_routing_states.dart';
import 'package:trusttunnel/feature/settings/app_routing/widgets/scope/app_routing_aspect.dart';
import 'package:trusttunnel/feature/settings/app_routing/widgets/scope/app_routing_scope_controller.dart';
import 'package:vpn_plugin/models/installed_app.dart';

class AppRoutingScope extends StatefulWidget {
  final Widget child;

  const AppRoutingScope({
    required this.child,
    super.key,
  });

  static AppRoutingScopeController controllerOf(
    BuildContext context, {
    bool listen = true,
    AppRoutingAspect? aspect,
  }) => _InheritedAppRoutingScope.controllerOf(context, listen: listen, aspect: aspect);

  @override
  State<AppRoutingScope> createState() => _AppRoutingScopeState();
}

class _AppRoutingScopeState extends State<AppRoutingScope> {
  late final AppRoutingController _controller;

  @override
  void initState() {
    super.initState();
    final repositoryFactory = context.repositoryFactory;
    final dependencyFactory = context.dependencyFactory;

    _controller = AppRoutingController(
      repository: repositoryFactory.appRoutingRepository,
      vpnPlugin: dependencyFactory.vpnPlugin,
    );
  }

  @override
  Widget build(BuildContext context) => StateConsumer<AppRoutingController, AppRoutingState>(
    controller: _controller,
    builder: (context, state, _) => _InheritedAppRoutingScope(
      state: state,
      fetch: _controller.fetch,
      changeMode: _controller.changeMode,
      toggleApp: _controller.toggleApp,
      submit: _controller.submit,
      child: widget.child,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _InheritedAppRoutingScope extends InheritedModel<AppRoutingAspect> implements AppRoutingScopeController {
  final AppRoutingState _state;

  const _InheritedAppRoutingScope({
    required AppRoutingState state,
    required this.fetch,
    required this.changeMode,
    required this.toggleApp,
    required this.submit,
    required super.child,
  }) : _state = state;

  @override
  final void Function() fetch;

  @override
  final AppRoutingModeChangedCallback changeMode;

  @override
  final AppRoutingAppToggledCallback toggleApp;

  @override
  final void Function(VoidCallback onSaved) submit;

  @override
  AppRoutingMode get mode => _state.mode;

  @override
  Set<String> get selectedPackages => Set<String>.unmodifiable(_state.selectedPackages);

  @override
  List<InstalledApp> get installedApps => List<InstalledApp>.unmodifiable(_state.installedApps);

  @override
  bool get loading => _state.loading;

  @override
  PresentationException? get error => _state.error;

  @override
  bool get hasChanges =>
      mode != _state.initialMode || !setEquals(selectedPackages, _state.initialSelectedPackages);

  @override
  bool updateShouldNotify(_InheritedAppRoutingScope oldWidget) => _state != oldWidget._state;

  static _InheritedAppRoutingScope controllerOf(
    BuildContext context, {
    bool listen = true,
    AppRoutingAspect? aspect,
  }) => _scope(context, listen: listen, aspect: aspect) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotifyDependent(
    covariant _InheritedAppRoutingScope oldWidget,
    Set<AppRoutingAspect> dependencies,
  ) {
    if (dependencies.isEmpty) return updateShouldNotify(oldWidget);

    bool hasAnyChanges = false;

    for (final aspect in dependencies) {
      hasAnyChanges |= switch (aspect) {
        AppRoutingAspect.loading => loading != oldWidget.loading,
        AppRoutingAspect.apps => !listEquals(installedApps, oldWidget.installedApps),
        AppRoutingAspect.data =>
          mode != oldWidget.mode ||
              !setEquals(selectedPackages, oldWidget.selectedPackages) ||
              error != oldWidget.error,
      };

      if (hasAnyChanges) return true;
    }

    return false;
  }

  static _InheritedAppRoutingScope? _scope(
    BuildContext context, {
    bool listen = true,
    AppRoutingAspect? aspect,
  }) => (listen
      ? InheritedModel.inheritFrom<_InheritedAppRoutingScope>(context, aspect: aspect)
      : context.getElementForInheritedWidgetOfExactType<_InheritedAppRoutingScope>()?.widget
            as _InheritedAppRoutingScope?);

  static Never _notFoundInheritedWidgetOfExactType<T extends InheritedModel<AppRoutingAspect>>() =>
      throw ArgumentError(
        'Inherited widget out of scope and not found of $T exact type',
        'out_of_scope',
      );
}
