package com.salesmate;

import android.content.Context;
import android.content.Intent;
import android.app.PendingIntent;
import android.app.AlarmManager;
import java.util.Calendar; // <-- Import Calendar
import android.util.Log;


public class AlarmManagerHelper {

    public static void scheduleAlarm(Context context) {
        // 1. Create an intent for the AlarmBroadcastReceiver
        Intent intent = new Intent(context, AlarmBroadcastReceiver.class);

        // 2. Create a PendingIntent
        PendingIntent pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT
        );

        // 3. Get the AlarmManager service
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);

        // 4. Create a Calendar instance and set it to 9:55 PM
        Calendar calendar = Calendar.getInstance(); // <-- Initialize Calendar
        calendar.setTimeInMillis(System.currentTimeMillis());
        calendar.set(Calendar.HOUR_OF_DAY, 2); // 9 P
        calendar.set(Calendar.MINUTE, 5);
        calendar.set(Calendar.SECOND, 0);

        // If time has already passed today, set it for tomorrow
        if (calendar.getTimeInMillis() < System.currentTimeMillis()) {
            calendar.add(Calendar.DAY_OF_YEAR, 1);
        }

        // 5. Schedule the alarm
        if (alarmManager != null) {
            alarmManager.setExact(
                AlarmManager.RTC_WAKEUP,
                calendar.getTimeInMillis(),
                pendingIntent
            );
        }
        Log.d("AlarmManagerHelper", "Scheduled alarm for: " + calendar.getTime());

    }
}
