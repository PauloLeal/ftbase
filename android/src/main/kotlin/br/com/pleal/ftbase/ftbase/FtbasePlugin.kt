package br.com.pleal.ftbase.ftbase

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FtbasePlugin */
class FtbasePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ftbase")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val argData = call.arguments as java.util.HashMap<String, String>
        val completed: Boolean

        if (call.method == "createNotificationChannel") {
            completed = doSomething(argData)
        } else {
            completed = false
        }

        if (completed) {
            result.success(completed)
        } else {
            result.error("Error Code", "Error Message", null)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun doSomething(mapData: HashMap<String, String>): Boolean {
        return true
    }
}
