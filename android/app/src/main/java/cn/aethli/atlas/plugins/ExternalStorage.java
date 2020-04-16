//package cn.aethli.atlas.plugins;
//
//import android.Manifest;
//import android.content.pm.PackageManager;
//import android.os.Environment;
//
//import androidx.annotation.NonNull;
//import androidx.core.app.ActivityCompat;
//import androidx.core.content.ContextCompat;
//
//import java.io.File;
//
//import io.flutter.embedding.engine.plugins.FlutterPlugin;
//import io.flutter.plugin.common.MethodCall;
//import io.flutter.plugin.common.MethodChannel;
//import io.flutter.plugin.common.PluginRegistry;
//
//public class ExternalStorage implements FlutterPlugin, MethodChannel.MethodCallHandler {
//    private static MethodChannel channel;
//
//    @Override
//    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
//        channel = new MethodChannel(binding.getFlutterEngine().getDartExecutor(), "ExternalStorage");
//        channel.setMethodCallHandler(new ExternalStorage());
//    }
//
//    public static void registerWith(PluginRegistry.Registrar registrar) {
//        final  MethodChannel channel = new MethodChannel(registrar.messenger(), "ExternalStorage");
//        channel.setMethodCallHandler(new ExternalStorage());
//    }
//
//    @Override
//    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
//        channel.setMethodCallHandler(null);
//    }
//
//    @Override
//    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
//        if (ContextCompat.checkSelfPermission(this,
//                Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
//            ActivityCompat.requestPermissions(this,
//                    new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, 0
//            );
//        }
//        if (ContextCompat.checkSelfPermission(this,
//                Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
//            ActivityCompat.requestPermissions(this,
//                    new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 0
//            );
//        }
//        if (call.method.equals("getExternalStoragePath")) {
//            boolean sdCardExist = false;
//            if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
//                sdCardExist = Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED);
//
//            }
//            File sdPath;
//            if (sdCardExist) {
//                sdPath = Environment.getExternalStorageDirectory();//获取根目录
//                result.success(sdPath.toString());
//            }
//        }
//    }
//}
