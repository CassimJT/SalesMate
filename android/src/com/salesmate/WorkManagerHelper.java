package com.salesmate;

import android.util.Log;
import androidx.work.WorkManager;
import androidx.work.OneTimeWorkRequest;
import android.content.Context;
import androidx.work.PeriodicWorkRequest;
import java.util.concurrent.TimeUnit;
import androidx.work.ExistingPeriodicWorkPolicy;

public class WorkManagerHelper {
    public static void scheduleWork(Context context) {
        OneTimeWorkRequest workRequest = new OneTimeWorkRequest.Builder(ScheduledWorker.class).build();
        WorkManager.getInstance(context).enqueue(workRequest);
    }
    //for periodic tasks
    public static void schedulePeriodicWork(Context context) {
        PeriodicWorkRequest periodicWork = new PeriodicWorkRequest.Builder(
            ScheduledWorker.class, //the class contain the do function
            15,//time intervel
            TimeUnit.MINUTES
        ).setInitialDelay(
            1,
            TimeUnit.MINUTES)
            .build();

        WorkManager.getInstance(context).enqueueUniquePeriodicWork(
            "qt_periodic_work",
            ExistingPeriodicWorkPolicy.REPLACE, //REPLCAE THE EXISTING WORK
            periodicWork
        );
    }
    //cancel the work
    public static void cancelWork(Context context) {
        WorkManager.getInstance(context).cancelUniqueWork("qt_periodic_work");
    }


}
