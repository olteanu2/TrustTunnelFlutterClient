import 'dart:ui';

import 'package:trusttunnel/common/error/model/presentation_exception.dart';
import 'package:trusttunnel/data/model/app_routing_settings.dart';
import 'package:vpn_plugin/models/installed_app.dart';

typedef AppRoutingModeChangedCallback = void Function(AppRoutingMode mode);
typedef AppRoutingAppToggledCallback = void Function(String packageName);

abstract class AppRoutingScopeController {
  abstract final AppRoutingMode mode;
  abstract final Set<String> selectedPackages;
  abstract final List<InstalledApp> installedApps;
  abstract final bool hasChanges;
  abstract final bool loading;

  abstract final PresentationException? error;

  abstract final void Function() fetch;
  abstract final AppRoutingModeChangedCallback changeMode;
  abstract final AppRoutingAppToggledCallback toggleApp;
  abstract final void Function(VoidCallback onSaved) submit;
}
