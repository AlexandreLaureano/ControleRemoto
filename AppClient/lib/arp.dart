import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:wifi/wifi.dart';

class Arp {
  static void searchDevices(String ip) {
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    final int port = 11111;

    final stream = NetworkAnalyzer.discover2(subnet, port);
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        print('Found device: ${addr.ip}');
      }
    }).onDone(() => print("finished"));
  }

  static Future<String> getIp() async {
    return await Wifi.ip;
  }

  static void search() async {
    const port = 11111;
    final stream = NetworkAnalyzer.discover2(
      '192.168.15',
      port,
      timeout: Duration(milliseconds: 5000),
    );

    int found = 0;
    stream.listen((NetworkAddress addr) {
      // print('${addr.ip}:$port');
      if (addr.exists) {
        found++;
        print('Found device: ${addr.ip}:$port');
      }
    }).onDone(() => print('Finish. Found $found device(s)'));
  }
}
