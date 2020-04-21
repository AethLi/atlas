package cn.aethli.atlas.plugins;

import android.app.Activity;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.LinkAddress;
import android.net.LinkProperties;
import android.net.Network;
import android.net.NetworkInfo;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.aethli.atlas.model.LanComputer;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;
import jcifs.UniAddress;
import jcifs.netbios.NbtAddress;
import jcifs.smb.SmbException;
import jcifs.smb.SmbFile;

public class Smb implements FlutterPlugin, ActivityAware {
    private static MethodChannel channel;
    private Activity activity;
    private List<InetAddress> addresses=new ArrayList<>();

    public static String longToIP(long longIp) {
        return (longIp >>> 24) +
                "." +
                ((longIp & 0x00FFFFFF) >>> 16) +
                "." +
                ((longIp & 0x0000FFFF) >>> 8) +
                "." +
                (longIp & 0x000000FF);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getFlutterEngine().getDartExecutor(), "smb");
        channel.setMethodCallHandler((call, result) -> {
            if (call.method.equals("getLanInfo")) {
                Map<String, Object> info = new HashMap<>();
                //get wifi info
                ConnectivityManager connMgr =
                        (ConnectivityManager) activity.getSystemService(Context.CONNECTIVITY_SERVICE);
                for (Network network : connMgr.getAllNetworks()) {
                    NetworkInfo networkInfo = connMgr.getNetworkInfo(network);
                    //if wifi conn
                    if (networkInfo.getType() == ConnectivityManager.TYPE_WIFI) {
                        LinkProperties linkProperties = connMgr.getLinkProperties(network);
                        List<LinkAddress> linkAddresses = linkProperties.getLinkAddresses();
                        //ipv4 ipv6 condition
                        for (LinkAddress linkAddress : linkAddresses) {
                            if (linkAddress.getAddress() instanceof Inet4Address) {

                                //get binary ipv4 address
                                byte[] address = linkAddress.getAddress().getAddress();
                                StringBuilder addressBuilder = new StringBuilder();
                                for (byte b : address) {
                                    StringBuilder partBuilder = new StringBuilder();
                                    partBuilder.append(Integer.toBinaryString(b & 0xFF));
                                    for (int i = partBuilder.length(); i < 8; i++) {
                                        partBuilder.insert(0, "0");
                                    }
                                    addressBuilder.append(partBuilder.toString());
                                }
                                String addressStr = addressBuilder.toString();
                                byte[] addressBytes = new byte[32];
                                char[] addressChars = addressStr.toCharArray();
                                for (int i = 0; i < addressChars.length; i++) {
                                    addressBytes[i] = Byte.parseByte(addressChars[i] + "");
                                }
                                //get prefix length
                                int prefixLength = linkAddress.getPrefixLength();
                                info.put("ipv4", addressBytes);
                                info.put("prefixLength", prefixLength);
                                result.success(info);
                            } else if (linkAddress.getAddress() instanceof Inet6Address) {
                                //todo ipv6 support
                            }
                        }
                    }
                }
            } else if (call.method.equals("getLanComputerSimply")) {
                List<LanComputer> computers = new ArrayList<>();
                //simple method get smb servers(never work)
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
                } catch (UnknownHostException | SmbException | MalformedURLException | ExceptionInInitializerError | NoClassDefFoundError e) {
                    e.printStackTrace();
                }
                result.success(computers);
            } else if (call.method.equals("getLanComputers")) {
                List ips = call.arguments();
                for (Object ip : ips) {
                    scanTask(longToIP((Long) ip));
                }

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

    private void scanTask(String ip) {
        new Thread(() -> {
            try {
                NbtAddress[] allByAddress = NbtAddress.getAllByAddress(ip);
                if (allByAddress != null) {
                    if (allByAddress.length > 0) {
                        addresses.add(allByAddress[0].getInetAddress());
                        System.out.println(Arrays.toString(allByAddress));
                    }
                }
            } catch (UnknownHostException e) {
            }
        }).start();
    }
}
