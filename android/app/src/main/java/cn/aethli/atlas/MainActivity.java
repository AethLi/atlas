package cn.aethli.atlas;

import android.os.Environment;

import androidx.annotation.NonNull;

import java.io.File;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        //内置储存的相关api调用
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "ExternalStorage")
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getExternalStoragePath")) {
                                boolean sdCardExist = false;
                                if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
                                    sdCardExist = Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED);
                                }
                                File sdPath;
                                if (sdCardExist) {
                                    sdPath = Environment.getExternalStorageDirectory();//获取根目录
                                    result.success(sdPath.toString());
                                }
                            }
                        }
                );
    }

}
