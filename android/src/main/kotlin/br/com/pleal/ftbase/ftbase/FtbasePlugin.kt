package br.com.pleal.ftbase.ftbase

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context.NOTIFICATION_SERVICE
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugins.firebase.messaging.ContextHolder.getApplicationContext

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
            completed = createNotificationChannel(argData)
        } else if (call.method == "deleteNotificationChannel") {
            completed = deleteNotificationChannel(argData)
        } else {
            completed = false
        }

        if (completed == true) {
            result.success(completed)
        } else {
            result.error("Error Code", "Error Message", null)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun deleteNotificationChannel(mapData: HashMap<String, String>): Boolean {
        val completed: Boolean
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val id = mapData["id"]

            val context = getApplicationContext();
            val notificationManager: NotificationManager =
                context.getSystemService(NOTIFICATION_SERVICE) as NotificationManager

            notificationManager.deleteNotificationChannel(id)
            completed = true
        } else {
            completed = false
        }
        return completed
    }

    private fun createNotificationChannel(mapData: HashMap<String, String>): Boolean {
        val completed: Boolean
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Create the NotificationChannel
            val id = mapData["id"]
            val name = mapData["name"]
            val descriptionText = mapData["description"]
            val action = mapData["action"]
//            val sound = "your_sweet_sound"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val mChannel = NotificationChannel(id, name, importance)
            mChannel.description = descriptionText

//            val soundUri =
//                Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + getApplicationContext().getPackageName() + "/raw/your_sweet_sound");
//            val att = AudioAttributes.Builder()
//                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
//                .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
//                .build();
//            mChannel.setSound(soundUri, att)

            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this

            val context = getApplicationContext();
            val notificationManager: NotificationManager =
                context.getSystemService(NOTIFICATION_SERVICE) as NotificationManager

            notificationManager.createNotificationChannel(mChannel)
            completed = true
        } else {
            completed = false
        }
        return completed
    }
}
