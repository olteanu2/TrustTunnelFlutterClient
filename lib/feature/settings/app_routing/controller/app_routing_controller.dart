import 'dart:ui';

import 'package:trusttunnel/common/controller/concurrency/sequential_controller_handler.dart';
import 'package:trusttunnel/common/controller/controller/state_controller.dart';
import 'package:trusttunnel/common/error/exception_utils.dart';
import 'package:trusttunnel/common/error/model/presentation_exception.dart';
import 'package:trusttunnel/data/model/app_routing_settings.dart';
import 'package:trusttunnel/data/repository/app_routing_repository.dart';
import 'package:trusttunnel/feature/settings/app_routing/controller/app_routing_states.dart';
import 'package:vpn_plugin/vpn_plugin.dart';

final class AppRoutingController extends BaseStateController<AppRoutingState> with SequentialControllerHandler {
  final AppRoutingRepository _repository;
  final VpnPlugin _vpnPlugin;

  AppRoutingController({
    required AppRoutingRepository repository,
    required VpnPlugin vpnPlugin,
    super.initialState = const AppRoutingState.initial(),
  }) : _repository = repository,
       _vpnPlugin = vpnPlugin;

  void fetch() => handle(
    () async {
      setState(
        AppRoutingState.loading(
          mode: state.mode,
          selectedPackages: state.selectedPackages,
          initialMode: state.initialMode,
          initialSelectedPackages: state.initialSelectedPackages,
          installedApps: state.installedApps,
        ),
      );

      final settings = await _repository.getSettings();
      final apps = await _vpnPlugin.getInstalledApps();
      final selected = settings.packages.toSet();

      setState(
        AppRoutingState.idle(
          mode: settings.mode,
          selectedPackages: selected,
          initialMode: settings.mode,
          initialSelectedPackages: selected,
          installedApps: apps,
        ),
      );
    },
    errorHandler: _onError,
    completionHandler: _onCompleted,
  );

  void changeMode(AppRoutingMode mode) => handle(
    () {
      setState(
        AppRoutingState.idle(
          mode: mode,
          selectedPackages: state.selectedPackages,
          initialMode: state.initialMode,
          initialSelectedPackages: state.initialSelectedPackages,
          installedApps: state.installedApps,
        ),
      );
    },
    errorHandler: _onError,
    completionHandler: _onCompleted,
  );

  void toggleApp(String packageName) => handle(
    () {
      final updated = Set<String>.of(state.selectedPackages);

      if (!updated.remove(packageName)) {
        updated.add(packageName);
      }

      setState(
        AppRoutingState.idle(
          mode: state.mode,
          selectedPackages: updated,
          initialMode: state.initialMode,
          initialSelectedPackages: state.initialSelectedPackages,
          installedApps: state.installedApps,
        ),
      );
    },
    errorHandler: _onError,
    completionHandler: _onCompleted,
  );

  void submit(VoidCallback onSaved) => handle(
    () async {
      setState(
        AppRoutingState.loading(
          mode: state.mode,
          selectedPackages: state.selectedPackages,
          initialMode: state.initialMode,
          initialSelectedPackages: state.initialSelectedPackages,
          installedApps: state.installedApps,
        ),
      );

      await _repository.setSettings(
        AppRoutingSettings(
          mode: state.mode,
          packages: state.selectedPackages.toList(),
        ),
      );

      setState(
        AppRoutingState.idle(
          mode: state.mode,
          selectedPackages: state.selectedPackages,
          initialMode: state.mode,
          initialSelectedPackages: state.selectedPackages,
          installedApps: state.installedApps,
        ),
      );

      onSaved();
    },
    errorHandler: _onError,
    completionHandler: _onCompleted,
  );

  PresentationException _parseException(Object? exception) =>
      ExceptionUtils.toPresentationException(exception: exception);

  Future<void> _onError(Object? error, StackTrace _) async {
    final presentationException = _parseException(error);

    setState(
      AppRoutingState.exception(
        exception: presentationException,
        mode: state.mode,
        selectedPackages: state.selectedPackages,
        initialMode: state.initialMode,
        initialSelectedPackages: state.initialSelectedPackages,
        installedApps: state.installedApps,
      ),
    );
  }

  Future<void> _onCompleted() async => setState(
    AppRoutingState.idle(
      mode: state.mode,
      selectedPackages: state.selectedPackages,
      initialMode: state.initialMode,
      initialSelectedPackages: state.initialSelectedPackages,
      installedApps: state.installedApps,
    ),
  );
}
