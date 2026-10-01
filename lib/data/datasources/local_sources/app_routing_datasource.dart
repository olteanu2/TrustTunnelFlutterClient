import 'package:shared_preferences/shared_preferences.dart';
import 'package:trusttunnel/data/model/app_routing_settings.dart';

abstract class AppRoutingDataSource {
  Future<AppRoutingSettings> get();

  Future<void> set(AppRoutingSettings settings);
}

class AppRoutingDataSourceImpl implements AppRoutingDataSource {
  static const _modeKey = 'app_routing_mode';
  static const _packagesKey = 'app_routing_packages';

  @override
  Future<AppRoutingSettings> get() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_modeKey) ?? 0;
    final mode = AppRoutingMode.values[modeIndex.clamp(0, AppRoutingMode.values.length - 1)];

    return AppRoutingSettings(
      mode: mode,
      packages: prefs.getStringList(_packagesKey) ?? const [],
    );
  }

  @override
  Future<void> set(AppRoutingSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_modeKey, settings.mode.index);
    await prefs.setStringList(_packagesKey, settings.packages);
  }
}
