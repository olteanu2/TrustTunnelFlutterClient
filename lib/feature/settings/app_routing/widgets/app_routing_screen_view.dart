import 'package:flutter/material.dart';
import 'package:trusttunnel/data/model/app_routing_settings.dart';
import 'package:trusttunnel/feature/settings/app_routing/widgets/scope/app_routing_scope.dart';

class AppRoutingScreenView extends StatelessWidget {
  const AppRoutingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppRoutingScope.controllerOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('App routing'),
        actions: [
          TextButton(
            onPressed: scope.hasChanges && !scope.loading
                ? () => scope.submit(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved')),
                    );
                  })
                : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: scope.loading && scope.installedApps.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                RadioGroup<AppRoutingMode>(
                  groupValue: scope.mode,
                  onChanged: (v) {
                    if (v != null) scope.changeMode(v);
                  },
                  child: const Column(
                    children: [
                      RadioListTile<AppRoutingMode>(
                        title: Text('Off (all apps use VPN)'),
                        value: AppRoutingMode.off,
                      ),
                      RadioListTile<AppRoutingMode>(
                        title: Text('Only selected apps use VPN'),
                        value: AppRoutingMode.onlySelected,
                      ),
                      RadioListTile<AppRoutingMode>(
                        title: Text('All apps except selected use VPN'),
                        value: AppRoutingMode.allExceptSelected,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: scope.mode == AppRoutingMode.off
                      ? const Center(child: Text('Choose a mode above to pick apps'))
                      : ListView.builder(
                          itemCount: scope.installedApps.length,
                          itemBuilder: (context, index) {
                            final app = scope.installedApps[index];
                            final selected = scope.selectedPackages.contains(app.packageName);

                            return CheckboxListTile(
                              title: Text(app.name),
                              value: selected,
                              onChanged: (_) => scope.toggleApp(app.packageName),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
