package com.salesmate;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.os.PowerManager;

public class AlarmReceiver extends BroadcastReceiver {
    private static final String TAG = "AlarmReceiver";

    @Override
    public void onReceive(Context context, Intent intent) {
        PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
        if (pm == null) {
            Log.e(TAG, "PowerManager is null!");
            return;
        }
        PowerManager.WakeLock wl = pm.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "salesmate:alarm"
        );
        try {
            wl.acquire(10 * 60 * 1000L);
            Log.d(TAG, "Alarm received - processing...");
            try {
                NativeBridge.invoked();
            } catch (Exception e) {
                Log.e(TAG, "NativeBridge failed: " + e.getMessage());
            }
            AlarmHelper.scheduleExactAlarm(context);
        } finally {
            if (wl != null && wl.isHeld()) {
                wl.release();
            }
        }
    }
}
