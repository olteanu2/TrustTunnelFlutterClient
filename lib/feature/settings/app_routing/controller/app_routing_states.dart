import 'package:trusttunnel/common/error/model/presentation_exception.dart';
import 'package:trusttunnel/data/model/app_routing_settings.dart';
import 'package:vpn_plugin/models/installed_app.dart';

sealed class AppRoutingState {
  final AppRoutingMode mode;
  final Set<String> selectedPackages;
  final AppRoutingMode initialMode;
  final Set<String> initialSelectedPackages;
  final List<InstalledApp> installedApps;

  const AppRoutingState._({
    required this.mode,
    required this.selectedPackages,
    required this.initialMode,
    required this.initialSelectedPackages,
    required this.installedApps,
  });

  const factory AppRoutingState.initial() = _InitialAppRoutingState;

  const factory AppRoutingState.idle({
    required AppRoutingMode mode,
    required Set<String> selectedPackages,
    required AppRoutingMode initialMode,
    required Set<String> initialSelectedPackages,
    required List<InstalledApp> installedApps,
  }) = _IdleAppRoutingState;

  const factory AppRoutingState.loading({
    required AppRoutingMode mode,
    required Set<String> selectedPackages,
    required AppRoutingMode initialMode,
    required Set<String> initialSelectedPackages,
    required List<InstalledApp> installedApps,
  }) = _LoadingAppRoutingState;

  const factory AppRoutingState.exception({
    required AppRoutingMode mode,
    required Set<String> selectedPackages,
    required AppRoutingMode initialMode,
    required Set<String> initialSelectedPackages,
    required List<InstalledApp> installedApps,
    required PresentationException exception,
  }) = _ErrorAppRoutingState;

  PresentationException? get error =>
      this is _ErrorAppRoutingState ? (this as _ErrorAppRoutingState).exception : null;

  bool get loading => this is _LoadingAppRoutingState;

  @override
  String toString() =>
      'AppRoutingState(type: $runtimeType, mode: $mode, '
      'selectedPackages: ${selectedPackages.length}, loading: $loading)';
}

final class _IdleAppRoutingState extends AppRoutingState {
  const _IdleAppRoutingState({
    required super.mode,
    required super.selectedPackages,
    required super.initialMode,
    required super.initialSelectedPackages,
    required super.installedApps,
  }) : super._();
}

final class _InitialAppRoutingState extends _IdleAppRoutingState {
  const _InitialAppRoutingState()
    : super(
        mode: AppRoutingMode.off,
        selectedPackages: const {},
        initialMode: AppRoutingMode.off,
        initialSelectedPackages: const {},
        installedApps: const [],
      );
}

final class _LoadingAppRoutingState extends AppRoutingState {
  const _LoadingAppRoutingState({
    required super.mode,
    required super.selectedPackages,
    required super.initialMode,
    required super.initialSelectedPackages,
    required super.installedApps,
  }) : super._();
}

final class _ErrorAppRoutingState extends AppRoutingState {
  final PresentationException exception;

  const _ErrorAppRoutingState({
    required super.mode,
    required super.selectedPackages,
    required super.initialMode,
    required super.initialSelectedPackages,
    required super.installedApps,
    required this.exception,
  }) : super._();
}
