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

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        @Suppress("UNCHECKED_CAST")
        val argData = call.arguments as java.util.HashMap<String, String>

        when (call.method) {
            "Notification.createChannel" -> Notification.createChannel(argData, result)
            "Notification.deleteChannel" -> Notification.deleteChannel(argData, result)
            "Notification.listChannels" -> Notification.listChannels(result)
            else -> throw NotImplementedError()
        }
    }
}
