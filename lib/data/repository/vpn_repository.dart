import 'dart:async';

import 'package:trusttunnel/data/datasources/local_sources/app_routing_datasource.dart';
import 'package:trusttunnel/data/datasources/vpn_datasource.dart';
import 'package:trusttunnel/data/model/app_routing_settings.dart';
import 'package:trusttunnel/data/model/routing_profile.dart';
import 'package:trusttunnel/data/model/server.dart';
import 'package:trusttunnel/data/model/vpn_configuration_log_level.dart';
import 'package:trusttunnel/data/model/vpn_log.dart';
import 'package:trusttunnel/data/model/vpn_state.dart';

abstract class VpnRepository {
  Future<void> start({
    required Server server,
    required RoutingProfile routingProfile,
    required List<String> excludedRoutes,
    required VpnConfigurationLogLevel logLevel,
  });

  Future<Stream<VpnState>> listenToStates();

  Future<void> updateConfiguration({
    required Server server,
    required RoutingProfile routingProfile,
    required List<String> excludedRoutes,
    required VpnConfigurationLogLevel logLevel,
  });

  Future<void> deleteConfiguration();

  Future<Stream<VpnLog>> listenToLogs();

  Future<VpnState> requestState();

  Future<void> stop();
}

class VpnRepositoryImpl implements VpnRepository {
  final VpnDataSource _vpnDataSource;
  final AppRoutingDataSource _appRoutingDataSource;

  VpnRepositoryImpl({
    required VpnDataSource vpnDataSource,
    required AppRoutingDataSource appRoutingDataSource,
  }) : _vpnDataSource = vpnDataSource,
       _appRoutingDataSource = appRoutingDataSource;

  Future<({List<String> allowed, List<String> disallowed})> _resolveAppRouting() async {
    final settings = await _appRoutingDataSource.get();
    switch (settings.mode) {
      case AppRoutingMode.off:
        return (allowed: <String>[], disallowed: <String>[]);
      case AppRoutingMode.onlySelected:
        return (allowed: settings.packages, disallowed: <String>[]);
      case AppRoutingMode.allExceptSelected:
        return (allowed: <String>[], disallowed: settings.packages);
    }
  }

  @override
  Future<void> start({
    required Server server,
    required List<String> excludedRoutes,
    required RoutingProfile routingProfile,
    required VpnConfigurationLogLevel logLevel,
  }) async {
    final routing = await _resolveAppRouting();
    return _vpnDataSource.start(
      server: server.serverData,
      routingProfile: routingProfile.data,
      excludedRoutes: excludedRoutes,
      logLevel: logLevel,
      allowedApps: routing.allowed,
      disallowedApps: routing.disallowed,
    );
  }

  @override
  Future<Stream<VpnState>> listenToStates() async => _vpnDataSource.vpnState;

  @override
  Future<void> stop() => _vpnDataSource.stop();

  @override
  Future<Stream<VpnLog>> listenToLogs() async => _vpnDataSource.vpnLogs;

  @override
  Future<VpnState> requestState() => _vpnDataSource.requestState();

  @override
  Future<void> updateConfiguration({
    required Server server,
    required RoutingProfile routingProfile,
    required List<String> excludedRoutes,
    required VpnConfigurationLogLevel logLevel,
  }) async {
    final routing = await _resolveAppRouting();
    await _vpnDataSource.updateConfiguration(
      server: server.serverData,
      routingProfile: routingProfile.data,
      excludedRoutes: excludedRoutes,
      logLevel: logLevel,
      allowedApps: routing.allowed,
      disallowedApps: routing.disallowed,
    );
  }

  @override
  Future<void> deleteConfiguration() => _vpnDataSource.deleteConfiguration();
}
