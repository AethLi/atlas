package cn.aethli.atlas.plugins;

import android.app.Activity;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.LinkAddress;
import android.net.LinkProperties;
import android.net.Network;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.util.ArrayMap;

import androidx.annotation.NonNull;

import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import cn.aethli.atlas.model.LanComputer;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;
import jcifs.UniAddress;
import jcifs.netbios.NbtAddress;
import jcifs.smb.SmbFile;

public class Smb implements FlutterPlugin, ActivityAware {
    private static MethodChannel channel;
    private Activity activity;

    private static String long2IP(long longIp) {
        return (longIp >>> 24) +
                "." +
                ((longIp & 0x00FFFFFF) >>> 16) +
                "." +
                ((longIp & 0x0000FFFF) >>> 8) +
                "." +
                (longIp & 0x000000FF);
    }

    private static long getNetworkSegment(long ip, int prefixLength) {
        long netMask = 0;
        for (int i = 0; i < prefixLength; i++) {
            netMask += Math.pow(2, (32 - i));
        }
        return ip & netMask;
    }

    private static long byteArray2LongIp(byte[] ipBytes) {
        long ipLong = 0;
        for (int i = 0; i < ipBytes.length; i++) {
            ipLong += (ipBytes[i] & 0xff) * Math.pow(2, (3 - i) * 8);
        }
        return ipLong;
    }


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getFlutterEngine().getDartExecutor(), "smb");
        channel.setMethodCallHandler((call, result) -> {
            if (call.method.equals("getLanComputers")) {
                new getLanInfoTask().execute(Collections.singletonMap("activity", activity));
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

    private static class getLanInfoTask extends AsyncTask<Map, Void, Void> {


        @Override
        protected Void doInBackground(Map... params) {
            Map<String, Object> info = new ArrayMap<>();
            //get wifi info
            ConnectivityManager connMgr = (ConnectivityManager) ((Activity) Objects.requireNonNull(params[0].get("activity"))).getSystemService(Context.CONNECTIVITY_SERVICE);
            for (Network network : connMgr.getAllNetworks()) {
                NetworkInfo networkInfo = connMgr.getNetworkInfo(network);
                //if wifi conn
                if (networkInfo.getType() == ConnectivityManager.TYPE_WIFI) {
                    LinkProperties linkProperties = connMgr.getLinkProperties(network);
                    List<LinkAddress> linkAddresses = linkProperties.getLinkAddresses();
                    //ipv4 ipv6 condition
                    for (LinkAddress linkAddress : linkAddresses) {
                        if (linkAddress.getAddress() instanceof Inet4Address) {

                            //get long ipv4 address
                            byte[] address = linkAddress.getAddress().getAddress();
                            long addressLong = byteArray2LongIp(address);
                            //get prefix length
                            int prefixLength = linkAddress.getPrefixLength();

                            //call back
                            info.put("ipv4", addressLong);
                            info.put("prefixLength", prefixLength);
//                            new getLanComputersSimply().execute(info);

                            //getLanComputers
                            long networkSegment = getNetworkSegment(addressLong, prefixLength);
                            ExecutorService executorService = Executors.newFixedThreadPool(10);
                            for (long i = 1; i < Math.pow(2, 32 - prefixLength) - 1; i++) {
                                new IpScannerAsyncTask().executeOnExecutor(executorService, long2IP(networkSegment + i));
                            }

                        } else if (linkAddress.getAddress() instanceof Inet6Address) {
                            //todo ipv6 support
                        }
                    }
                }
            }
            return null;
        }
    }

    private static class getLanComputersSimply extends AsyncTask<Map, Void, Void> {

        @Override
        protected Void doInBackground(Map... maps) {
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
            } catch (Exception e) {
                e.printStackTrace();
            }
//            ((MethodChannel) Objects.requireNonNull(maps[0].get("channel"))).invokeMethod("", computers);
            //todo result call back
            return null;
        }
    }

    private static class IpScannerAsyncTask extends AsyncTask<String, Void, LanComputer> {

        @Override
        protected LanComputer doInBackground(@NonNull String... strings) {
            String ip = strings[0];
            try {
                NbtAddress[] nbtAddresses = NbtAddress.getAllByAddress(ip);

                if (nbtAddresses != null) {
                    for (NbtAddress byAddress : nbtAddresses) {
                        if (!(byAddress.isGroupAddress() || byAddress.getHostName().contains("WORKGROUP"))) {
                            LanComputer computer = new LanComputer();
                            computer.setHostName(byAddress.getHostName());
                            computer.setIpv4(long2IP(byteArray2LongIp(byAddress.getAddress())));
                            return computer;
                        }
                    }

                }
            } catch (UnknownHostException e) {
            }
            return null;
        }

        @Override
        protected void onPostExecute(LanComputer lanComputer) {
            if (lanComputer == null) {
                return;
            }
            channel.invokeMethod("computersUpdate", lanComputer.toMap());
        }
    }

}