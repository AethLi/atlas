package cn.aethli.atlas;

import android.Manifest;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Environment;
import android.text.format.Formatter;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.io.File;
import java.net.MalformedURLException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

import cn.aethli.atlas.model.LanComputer;
import cn.aethli.atlas.plugins.PluginRegister;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import jcifs.UniAddress;
import jcifs.smb.SmbException;
import jcifs.smb.SmbFile;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        PluginRegister.registerWith(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

}
