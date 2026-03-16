package com.moneyup;

import android.app.Application;

public class NotificationStartupChannel extends Application {

    @Override
    public void onCreate() {
        super.onCreate();

        // Call your helper to create the channel
        NotificationHelper.createNotificationChannel(this);
    }
}
