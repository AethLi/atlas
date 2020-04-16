package cn.aethli.atlas;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Environment;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

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

                            if (ContextCompat.checkSelfPermission(this,
                                    Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                                ActivityCompat.requestPermissions(this,
                                        new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, 0
                                );
                            }
                            if (ContextCompat.checkSelfPermission(this,
                                    Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                                ActivityCompat.requestPermissions(this,
                                        new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 0
                                );
                            }

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
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "smb").setMethodCallHandler(
                (call, result) -> {

                }
        );
    }

}
