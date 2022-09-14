package br.com.pleal.ftbase.ftbase

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.firebase.messaging.ContextHolder

class Notification {
    companion object {
        private fun notificationManager(): NotificationManager {
            val context = ContextHolder.getApplicationContext();
            return context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        }

        fun listChannels(result: MethodChannel.Result) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                return result.error(
                    "INVALID_SDK_VERSION",
                    "Invalid SDK version",
                    null
                )
            }

            val channels = notificationManager().notificationChannels.map { notificationChannel ->
                val d = HashMap<String, String>()
                d["id"] = notificationChannel.id
                d["name"] = notificationChannel.name.toString()
                d["description"] = notificationChannel.description
                d
            }.toList()

            return result.success(channels)
        }

        fun deleteChannel(mapData: HashMap<String, String>, result: MethodChannel.Result) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                return result.error(
                    "INVALID_SDK_VERSION",
                    "Invalid SDK version",
                    null
                )
            }

            val id = mapData["id"]

            notificationManager().deleteNotificationChannel(id)
            return result.success(true)
        }

        fun createChannel(mapData: HashMap<String, String>, result: MethodChannel.Result) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                return result.error(
                    "INVALID_SDK_VERSION",
                    "Invalid SDK version",
                    null
                )
            }

            // Create the NotificationChannel
            val id = mapData["id"]
            val name = mapData["name"]
            val descriptionText = mapData["description"]
//            val action = mapData["action"]
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

            notificationManager().createNotificationChannel(mChannel)

            return result.success(true)
        }
    }
}