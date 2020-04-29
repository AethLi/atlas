package cn.aethli.atlas.plugins;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Environment;
import android.os.StatFs;
import android.text.format.Formatter;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;

public class ExternalStorage implements FlutterPlugin, ActivityAware {
    private static MethodChannel channel;
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getFlutterEngine().getDartExecutor(), "ExternalStorage");
        channel.setMethodCallHandler((call, result) -> {
            if (ContextCompat.checkSelfPermission(activity,
                    Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(activity,
                        new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, 0
                );
            }
            if (ContextCompat.checkSelfPermission(activity,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(activity,
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
            } else if (call.method.equals("getExternalSpaceInfo")) {
                Map<String, String> info = new HashMap<>();
                long freeSpace = Environment.getDataDirectory().getFreeSpace();
//                long rootSpace = new StatFs("/").getAvailableBytes();
                long externalStorageSpace = new StatFs(Environment.getExternalStorageDirectory().toString()).getAvailableBytes();
                info.put("freeSpace", Formatter.formatFileSize(this.activity, freeSpace));
                info.put("localSpace", Formatter.formatFileSize(this.activity, /*rootSpace +*/ externalStorageSpace));
                if (ExistSDCard()) {
                    long SDFreeSpace = Environment.getExternalStorageDirectory().getFreeSpace();
                    info.put("sd", Formatter.formatFileSize(this.activity, SDFreeSpace));
                }
                result.success(info);
            }
        });
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        this.activity = null;
    }

    @Override
    public void onDetachedFromActivity() {
        this.activity = null;
    }

    /**
     * check sd card
     *
     * @return true:exist,false:not exist
     */
    private boolean ExistSDCard() {
        return ContextCompat.getExternalFilesDirs(this.activity, null).length >= 2;
    }

}
