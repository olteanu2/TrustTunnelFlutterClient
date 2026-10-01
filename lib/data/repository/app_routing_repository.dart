import 'package:trusttunnel/data/datasources/local_sources/app_routing_datasource.dart';
import 'package:trusttunnel/data/model/app_routing_settings.dart';

abstract class AppRoutingRepository {
  Future<AppRoutingSettings> getSettings();

  Future<void> setSettings(AppRoutingSettings settings);
}

class AppRoutingRepositoryImpl implements AppRoutingRepository {
  final AppRoutingDataSource _dataSource;

  AppRoutingRepositoryImpl({
    required AppRoutingDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<AppRoutingSettings> getSettings() => _dataSource.get();

  @override
  Future<void> setSettings(AppRoutingSettings settings) => _dataSource.set(settings);
}
