package br.com.pleal.ftbase.ftbase_example

import android.app.NotificationManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    val notificationManager = ContextCompat.getSystemService(NOTIFICATION_SERVICE) as NotificationManager

}
