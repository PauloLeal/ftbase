# ftbase


### Add this to MainActivity for notifications
```kotlin
 private val channel = "ftbase-notifications"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->

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
    }

    private fun deleteNotificationChannel(mapData: HashMap<String, String>): Boolean {
        val completed: Boolean
        if (VERSION.SDK_INT >= VERSION_CODES.O) {
            val id = mapData["id"]

            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.deleteNotificationChannel(id)
            completed = true
        } else {
            completed = false
        }
        return completed
    }

    private fun createNotificationChannel(mapData: HashMap<String, String>): Boolean {
        val completed: Boolean
        if (VERSION.SDK_INT >= VERSION_CODES.O) {
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
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)
            completed = true
        } else {
            completed = false
        }
        return completed
    }
```