package com.salesmate;

import android.content.Context;
import android.content.Intent;
import android.content.BroadcastReceiver;
import android.util.Log;

public class AlarmBroadcastReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d("AlarmBroadcastReceiver", "Received intent: " + intent.getAction());

        if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
            Log.d("AlarmBroadcastReceiver", "Boot completed. Rescheduling alarm.");
            AlarmManagerHelper.scheduleAlarm(context); // Reschedule the alarm on boot
        } else {
            Log.d("AlarmBroadcastReceiver", "Alarm triggered! Launching app...");
            Intent launchIntent = new Intent(context, org.qtproject.qt.android.bindings.QtActivity.class);
            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);  // Ensure a new task is started
            context.startActivity(launchIntent);
        }
    }
}
