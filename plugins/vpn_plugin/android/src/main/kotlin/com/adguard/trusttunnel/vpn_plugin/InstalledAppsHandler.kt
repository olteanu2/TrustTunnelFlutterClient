package com.adguard.trusttunnel.vpn_plugin

import android.Manifest
import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class InstalledAppsHandler(private val context: Context) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != "getInstalledApps") {
            result.notImplemented()
            return
        }
        val main = Handler(Looper.getMainLooper())
        Thread {
            try {
                val apps = getInstalledApps(context)
                main.post { result.success(apps) }
            } catch (e: Exception) {
                main.post { result.error("APPS_ERROR", e.message, null) }
            }
        }.start()
    }

    private fun getInstalledApps(context: Context): List<Map<String, Any>> {
        val pm = context.packageManager
        val apps = pm.getInstalledApplications(PackageManager.GET_META_DATA)

        return apps
            .filter { appInfo ->
                val hasLauncherIcon = pm.getLaunchIntentForPackage(appInfo.packageName) != null
                val requestsInternet = pm.checkPermission(
                    Manifest.permission.INTERNET,
                    appInfo.packageName,
                ) == PackageManager.PERMISSION_GRANTED

                hasLauncherIcon && requestsInternet
            }
            .map { appInfo ->
                mapOf(
                    "package" to appInfo.packageName,
                    "name" to pm.getApplicationLabel(appInfo).toString(),
                    "system" to ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0),
                )
            }
            .sortedBy { (it["name"] as String).lowercase() }
    }
}
