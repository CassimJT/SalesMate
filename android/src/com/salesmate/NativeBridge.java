package com.salesmate;

import android.util.Log;

public class NativeBridge {
    static {
        try {
          System.loadLibrary("appSalesMate_armeabi-v7a");
          Log.d("NativeBridge", "Library loaded...");
        } catch (UnsatisfiedLinkError e) {
            Log.e("NativeBridge", "Library load error", e);
        }
    }
    public static native void invoked();
}
