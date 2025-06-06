package com.salesmate;

import android.util.Log;
import android.content.Context;
import androidx.work.Worker;
import androidx.work.WorkerParameters;
import java.util.concurrent.TimeUnit;


public class ScheduledWorker extends Worker {
    private static final String TAG = "QtWorkManager";
    public ScheduledWorker(Context context,WorkerParameters params){
        super(context,params);
    }

   @Override
    public Result doWork() {
        Log.d(TAG,"Executing periodic work");
        /*try{
            Thread.sleep(TimeUnit.SECONDS.toMillis(30));
        }catch(InterruptedException e){
            return Result.failure();
        }*/
        //work to be done
        Log.d(TAG,"Working....");
        return Result.success();
    }
}
