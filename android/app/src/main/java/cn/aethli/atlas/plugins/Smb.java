package cn.aethli.atlas.plugins;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.text.format.Formatter;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.net.MalformedURLException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

import cn.aethli.atlas.model.LanComputer;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;
import jcifs.UniAddress;
import jcifs.smb.SmbException;
import jcifs.smb.SmbFile;

public class Smb implements FlutterPlugin, ActivityAware {
    private static MethodChannel channel;
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getFlutterEngine().getDartExecutor(), "smb");
        channel.setMethodCallHandler((call, result) -> {

            if (ContextCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_WIFI_STATE) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.ACCESS_WIFI_STATE}, 0);
            }

            if (call.method.equals("getLanComputers")) {
                List<LanComputer> computers = new ArrayList<>();
                WifiManager wifiManager = (WifiManager) activity.getSystemService("wifi");
                WifiInfo connectionInfo = wifiManager.getConnectionInfo();
                int currentIp = connectionInfo.getIpAddress();
                if (currentIp != 0) {
                    try {
                        SmbFile smbFile = new SmbFile("smb://");
                        smbFile.setConnectTimeout(2000);
                        for (SmbFile listFiles : smbFile.listFiles()) {
                            SmbFile[] listFiles2 = listFiles.listFiles();
                            for (int i2 = 0; i2 < listFiles2.length; i2++) {
                                String substring = listFiles2[i2].getName().substring(0, listFiles2[i2].getName().length() - 1);
                                UniAddress byName = UniAddress.getByName(substring);
                                if (byName != null) {
                                    computers.add(new LanComputer(substring, byName.getHostAddress()));
                                }

                            }
                        }
                    } catch (UnknownHostException | SmbException | MalformedURLException e) {
                        e.printStackTrace();
                    }
                    String formatIpAddress = Formatter.formatIpAddress(currentIp);
                    String substring = formatIpAddress.substring(0, formatIpAddress.lastIndexOf(46) + 1);


                }
                result.success(computers);
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

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
