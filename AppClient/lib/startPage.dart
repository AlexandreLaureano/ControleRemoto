import 'package:clientMouse/global.dart';
import 'package:flutter/material.dart';
import 'ControlWidget.dart';

import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:wifi/wifi.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<String> _lista = <String>[];
  String _error = "";

  int _itemCount = 0;

  @override
  void initState() {
    _searchDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: SizedBox(
                    height: 200.0,
                    child: (_lista.isEmpty) ? _buscando() : _encontrado())),
          ],
        ),
      ),
    );
  }

  Widget _encontrado() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
        ),
        Text("Dispostivos Encontrados"),
        Container(
          child: Expanded(
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: _itemCount,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(_lista[index]),
                      onTap: () => _pressItem(_lista[index]),
                    );
                  })),
        ),
      ],
    );
  }

  Widget _buscando() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Nenhum Dispostivo Encontrado"),
        Text("Verifique se o servidor está online \n"),
        Text(_error),
        Container(
          height: 50,
        ),
        OutlineButton(
            onPressed: () => _searchDevices, child: Text("Atualizar")),
      ],
    ));
  }

  _pressItem(String item) {
    Global.ip = item;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ControlWidget()));
  }

  _searchDevices() async {
    String ip;
    try {
      ip = await Wifi.ip;
      String subnet = ip.substring(0, ip.lastIndexOf('.'));
      int port = 11111;

      //Alterar método dicover2, incluindo socket.write("done");
      final stream = NetworkAnalyzer.discover2(subnet, port);
      stream.listen((NetworkAddress addr) {
        if (addr.exists) {
          setState(() {
            _lista.add(addr.ip);
            _itemCount++;
          });
        }
      }).onDone(() => print("finished"));
    } catch (ex) {
      setState(() => _error = "Verifique o WIFI");
    }
  }
}
