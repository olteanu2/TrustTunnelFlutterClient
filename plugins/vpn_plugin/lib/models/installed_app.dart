/// An application installed on the device.
class InstalledApp {
  const InstalledApp({
    required this.packageName,
    required this.name,
    required this.isSystem,
  });

  factory InstalledApp.fromMap(Map<Object?, Object?> map) => InstalledApp(
    packageName: map['package']! as String,
    name: map['name']! as String,
    isSystem: (map['system'] as bool?) ?? false,
  );

  final String packageName;
  final String name;
  final bool isSystem;
}
