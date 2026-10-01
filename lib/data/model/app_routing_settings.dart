enum AppRoutingMode { off, onlySelected, allExceptSelected }

class AppRoutingSettings {
  const AppRoutingSettings({
    this.mode = AppRoutingMode.off,
    this.packages = const [],
  });

  final AppRoutingMode mode;
  final List<String> packages;

  List<String> get allowedApps => mode == AppRoutingMode.onlySelected ? packages : const [];

  List<String> get disallowedApps => mode == AppRoutingMode.allExceptSelected ? packages : const [];
}
