import 'package:flutter/material.dart';
import 'package:trusttunnel/feature/settings/app_routing/widgets/app_routing_screen_view.dart';
import 'package:trusttunnel/feature/settings/app_routing/widgets/scope/app_routing_scope.dart';

class AppRoutingScreen extends StatefulWidget {
  const AppRoutingScreen({super.key});

  @override
  State<AppRoutingScreen> createState() => _AppRoutingScreenState();
}

class _AppRoutingScreenState extends State<AppRoutingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppRoutingScope.controllerOf(context, listen: false).fetch();
    });
  }

  @override
  Widget build(BuildContext context) => const AppRoutingScreenView();
}
