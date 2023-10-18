package org.ola.parlance;

//import com.microsoft.appcenter.AppCenter;
//import com.microsoft.appcenter.analytics.Analytics;
//import com.microsoft.appcenter.crashes.Crashes;
//import com.microsoft.appcenter.distribute.Distribute;
import org.qtproject.qt5.android.bindings.QtActivity;
import android.os.Bundle;
import android.view.WindowManager;
import android.view.Window;

public class ParlanceActivity extends QtActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
//        AppCenter.start(getApplication(),
//            "d485895c-a1be-4a78-860c-996dc26e5d6f",
//            Analytics.class,
//            Crashes.class,
//            Distribute.class
//        );
        super.onCreate(savedInstanceState);
         getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

    }

}
