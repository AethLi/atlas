package cn.aethli.atlas;

import androidx.annotation.NonNull;

import cn.aethli.atlas.plugins.PluginRegister;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        PluginRegister.registerWith(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

}
