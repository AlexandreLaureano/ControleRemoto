import 'package:clientMouse/conexao.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;

import 'global.dart';

class MainContent extends StatefulWidget {
  final Function callback;

  MainContent({this.callback});

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  int _x1 = 0, _y1 = 0, _x2 = 0, _y2 = 0;
  double _width, _height;

  @override
  void initState() {
    super.initState();
    HardwareButtons.volumeButtonEvents.listen((event) {
      if (event.index == 0)
        Conexao.sendCommand("volUp");
      else
        Conexao.sendCommand("volDown");
    });
  }

  /// Track current point of a gesture
  void _onDragUpdateHandler(DragUpdateDetails details) {
    double delta = details.primaryDelta;
    if (delta < 0) delta = delta * -1;
    if (details.globalPosition.dx.floor() % 1 == 0 ||
        details.globalPosition.dy.floor() % 1 == 0) {
      _x2 = details.globalPosition.dx.floor();
      _y2 = details.globalPosition.dy.floor();
      if (_x1 != _x2 && _y1 != _y2) {
        Conexao.move(((_x1 - _x2) * (delta + 1)).floor(),
            ((_y1 - _y2) * (delta + 1)).floor());
        _x1 = details.globalPosition.dx.floor();
        _y1 = details.globalPosition.dy.floor();
      }
    }
  }

  void _onpanStartHandler(DragStartDetails details) {
    _x1 = details.globalPosition.dx.floor();
    _y1 = details.globalPosition.dy.floor();
  }

  void _onTap() => Conexao.sendCommand("leftclick");

  void _onDoubleTap() => Conexao.sendCommand("doubleclick");

  void _onLongPress() => Conexao.sendCommand("rightclick");

  void _ontapUpHandler(DragEndDetails details) {}

  @override
  Widget build(BuildContext context) {
    _width = Global.getWidth(context);
    _height = Global.getHeight(context);
    return Column(children: [
      mousePainel(_height),
      buttonMouse(_width),
      selecTab(),
    ]);
  }

  Widget selecTab() {
    switch (Global.tab) {
      case 0:
        return tecladoMidia();
        break;
      case 1:
        return teclado();
        break;
      case 2:
        return util();
        break;
      default:
        return tecladoMidia();
    }
  }

  Widget util() {
    return Column(children: [
      Row(children: [
        teclaF("F1"),
        teclaF("F2"),
        teclaF("F3"),
        teclaF("F4"),
        teclaF("F5"),
        teclaF("F6"),
      ]),
      Row(
        children: [
          teclaF("F7"),
          teclaF("F8"),
          teclaF("F9"),
          teclaF("F10"),
          teclaF("F11"),
          teclaF("F12")
        ],
      ),
    ]);
  }

  Widget teclado() {
    return Column(
      children: [
        Row(
          children: [
            tecla("1"),
            tecla("2"),
            tecla("3"),
            tecla("4"),
            tecla("5"),
            tecla("6"),
            tecla("7"),
            tecla("8"),
            tecla("9"),
            tecla("0")
          ],
        ),
        Row(
          children: [
            tecla("q"),
            tecla("w"),
            tecla("e"),
            tecla("r"),
            tecla("t"),
            tecla("y"),
            tecla("u"),
            tecla("i"),
            tecla("o"),
            tecla("p")
          ],
        ),
        Row(
          children: [
            tecla("a"),
            tecla("s"),
            tecla("d"),
            tecla("f"),
            tecla("g"),
            tecla("h"),
            tecla("j"),
            tecla("k"),
            tecla("l"),
            tecla("ç")
          ],
        ),
        Row(
          children: [
            tecla("z"),
            tecla("x"),
            tecla("c"),
            tecla("v"),
            tecla("b"),
            tecla("n"),
            tecla("m"),
            tecla(","),
            tecla("."),
            tecla(";")
          ],
        ),
      ],
    );
  }

  Widget teclaF(String letra) {
    return Padding(
      padding: EdgeInsets.only(left: 1, right: 1),
      child: Container(
        width: _width / 6 - 2,
        child: OutlineButton(
          onPressed: () => sendKey(letra),
          child: Text(
            letra,
            style: TextStyle(fontSize: 10, wordSpacing: 2),
          ),
        ),
      ),
    );
  }

  Widget tecla(String letra) {
    return Padding(
      padding: EdgeInsets.only(left: 1, right: 1),
      child: Container(
        width: _width / 10 - 2,
        child: OutlineButton(
          onPressed: () => sendKey(letra),
          child: Text(letra),
        ),
      ),
    );
  }

  void sendKey(String key) {}

  Widget tecladoMidia() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            painelMidia(),
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () => Conexao.sendCommand("stop")),
                IconButton(
                    icon: const Icon(Icons.volume_mute),
                    onPressed: () => Conexao.sendCommand("volMute")),
                IconButton(
                    onPressed: () => Conexao.sendCommand("tab"),
                    icon: Icon(Icons.keyboard_tab))
              ],
            ),
          ],
        ),
        Column(
          children: [
            painelMovimento(),
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Conexao.sendCommand("esc")),
                IconButton(
                    icon: Icon(Icons.keyboard_backspace),
                    onPressed: () => Conexao.sendCommand("back")),
                IconButton(
                    icon: Icon(Icons.fullscreen),
                    onPressed: () => Conexao.sendCommand("f")),
                IconButton(
                    icon: Icon(Icons.space_bar),
                    onPressed: () => Conexao.sendCommand("space")),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget painelMidia() {
    return Column(
      children: [
        Row(
          children: [
            TextButton(onPressed: null, child: null),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () => Conexao.sendCommand("volUp")),
            TextButton(onPressed: null, child: null),
          ],
        ),
        Row(
          children: [
            IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () => Conexao.sendCommand("previous")),
            IconButton(
                icon: Icon(Icons.play_circle_fill),
                onPressed: () => Conexao.sendCommand("play")),
            IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () => Conexao.sendCommand("next")),
          ],
        ),
        Row(
          children: [
            TextButton(onPressed: null, child: null),
            IconButton(
              onPressed: () => Conexao.sendCommand("volDown"),
              icon: const Icon(Icons.remove),
            ),
            TextButton(onPressed: null, child: null),
          ],
        ),
      ],
    );
  }

  Widget painelMovimento() {
    return Column(
      children: [
        Row(
          children: [
            TextButton(onPressed: null, child: null),
            IconButton(
                icon: Icon(Icons.keyboard_arrow_up),
                onPressed: () => Conexao.sendCommand("up")),
            TextButton(onPressed: null, child: null),
          ],
        ),
        Row(
          children: [
            IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () => Conexao.sendCommand("left")),
            IconButton(
                icon: Icon(Icons.keyboard_return),
                onPressed: () => Conexao.sendCommand("enter")),
            IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () => Conexao.sendCommand("right")),
          ],
        ),
        Row(
          children: [
            TextButton(onPressed: null, child: null),
            IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                onPressed: () => Conexao.sendCommand("down")),
            TextButton(onPressed: null, child: null),
          ],
        ),
      ],
    );
  }

  Widget mousePainel(double height) {
    return GestureDetector(
        // onPanStart: _onTap,
        //onPanUpdate: _onDragUpdateHandler,
        //onPanEnd: _ontapUpHandler,
        onDoubleTap: _onDoubleTap,
        onLongPress: _onLongPress,
        onTap: _onTap,
        onHorizontalDragStart: _onpanStartHandler,
        onVerticalDragStart: _onpanStartHandler,
        onVerticalDragEnd: _ontapUpHandler,
        onHorizontalDragEnd: _ontapUpHandler,
        onHorizontalDragUpdate: _onDragUpdateHandler,
        onVerticalDragUpdate: _onDragUpdateHandler,
        dragStartBehavior: DragStartBehavior.start, // default
        child: Container(
          height: height * .5,
          color: Colors.black26,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          )),
        ));
  }

  Widget buttonMouse(double width) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: width * .05, right: width * .05),
          child: Container(
            child: OutlineButton(
              onPressed: () => Conexao.sendCommand("leftclick"),
            ),
            width: width * .35,
            height: 40,
            color: Colors.grey,
          ),
        ),
        Container(
          child: OutlineButton(
            onPressed: () => Conexao.sendCommand("middleclick"),
          ),
          width: width * .1,
          height: 40,
          color: Colors.grey,
        ),
        Padding(
          padding: EdgeInsets.only(left: width * .05, right: width * .05),
          child: Container(
            child: OutlineButton(
              onPressed: () => Conexao.sendCommand("rightclick"),
            ),
            width: width * .35,
            height: 40,
            color: Colors.grey,
          ),
        )
      ],
    );
  }

  Widget circle() {
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90), color: Colors.cyan),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () => Conexao.move(10, 10)),
                IconButton(
                    padding: EdgeInsets.only(bottom: 15),
                    icon: Icon(Icons.arrow_left),
                    onPressed: () => Conexao.move(0, 10)),
                IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () => Conexao.move(-10, 10))
              ],
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_left),
                    padding: EdgeInsets.only(right: 15),
                    onPressed: () => Conexao.move(10, 0)),
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: Colors.cyanAccent),
                  child: IconButton(
                      icon: Icon(Icons.arrow_left),
                      onPressed: () => Conexao.sendCommand("middleclick")),
                ),
                IconButton(
                    icon: Icon(Icons.arrow_left),
                    padding: EdgeInsets.only(left: 15),
                    onPressed: () => Conexao.move(-10, 0))
              ],
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () => Conexao.move(10, -10)),
                IconButton(
                    icon: Icon(Icons.arrow_left),
                    padding: EdgeInsets.only(top: 15),
                    onPressed: () => Conexao.move(0, -10)),
                IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () => Conexao.move(-10, -10))
              ],
            )
          ],
        ));
  }
}
