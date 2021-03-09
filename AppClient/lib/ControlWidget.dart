import 'package:clientMouse/conexao.dart';
import 'package:clientMouse/global.dart';
import 'package:clientMouse/mainContent.dart';
import 'package:flutter/material.dart';

class ControlWidget extends StatefulWidget {
  @override
  _AudioServiceWidgetState createState() => _AudioServiceWidgetState();
}

class _AudioServiceWidgetState extends State<ControlWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    connect();
  }

  @override
  void dispose() {
    desconnect();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        connect();
        break;
      case AppLifecycleState.paused:
        desconnect();
        break;
      default:
        break;
    }
  }

  @override
  Future<bool> didPopRoute() async {
    desconnect();
    return false;
  }

  void connect() {
    setState(() {
      Conexao.conectar();
    });
  }

  void desconnect() {
    setState(() {
      Conexao.dc();
    });
  }

  void alterarTeclado(int i) {
    setState(() {
      Global.tab = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavBar = BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: Global.tab,
        onTap: (int index) {
          alterarTeclado(index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.perm_media), label: 'Media'),
          BottomNavigationBarItem(
              icon: Icon(Icons.keyboard), label: 'KeyBoard'),
          BottomNavigationBarItem(icon: Icon(Icons.functions), label: "Others")
        ]);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Remote Control"),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: TextButton(
                    onPressed: () => connect(), child: Text("Conectar")),
              ),
              PopupMenuItem(
                child: TextButton(
                    onPressed: () => desconnect(), child: Text("Desconectar")),
              )
            ];
          })
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: MainContent(
          callback: alterarTeclado,
        ),
      ),
      bottomNavigationBar: bottomNavBar,
    );
  }
}
