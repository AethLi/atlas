package cn.aethli.atlas.model;

public class LanComputer {
    private String hostName;
    private String ipv4;
    private String ipv6;

    public LanComputer() {
    }

    public LanComputer(String hostName, String ipv4) {
        this.hostName = hostName;
        this.ipv4 = ipv4;
    }

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }

    public String getIpv4() {
        return ipv4;
    }

    public void setIpv4(String ipv4) {
        this.ipv4 = ipv4;
    }

    public String getIpv6() {
        return ipv6;
    }

    public void setIpv6(String ipv6) {
        this.ipv6 = ipv6;
    }
}
