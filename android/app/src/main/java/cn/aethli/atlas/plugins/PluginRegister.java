package cn.aethli.atlas.plugins;

import android.app.Activity;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

@Keep
public final class PluginRegister {
    public static void registerWith(@NonNull FlutterEngine flutterEngine){
        flutterEngine.getPlugins().add(new ExternalStorage());
        flutterEngine.getPlugins().add(new Smb());
    }
}
