import 'dart:io';
import 'package:clientMouse/global.dart';
import 'package:flutter/material.dart';

class Conexao {
  static Socket _socket;

  static void conectar() {
    try {
      //_socket = await Socket.connect("192.168.15.106", 11111);
      Socket.connect(Global.ip, 11111).then((Socket sock) {
        _socket = sock;
        _socket.listen(dataHandler,
            onError: errorHandler, onDone: doneHandler, cancelOnError: false);
      }).catchError((AsyncSnapshot e) {
        print("Unable to connect: $e");
      });
    } catch (ex) {}
  }

  static void dataHandler(data) {
    String status = String.fromCharCodes(data).trim();

    Global.status = status;
  }

  static void errorHandler(error, StackTrace trace) => print(error);

  static void doneHandler() => _socket.destroy();

  static void desconectar() async => await _socket.close();

  static void dc() {
    try {
      Global.status = "OFF";
      _socket.write("done");
    } catch (e) {
      print("EX" + e.ToString());
    } finally {}
  }

  static void move(int x, int y) {
    try {
      //print("mov;${x.toString()};${y.toString()}");
      _socket.writeln("mov;${x.toString()};${y.toString()};");
    } catch (e) {
      print("EX" + e.ToString());
    }
  }

  static void sendCommand(String com) {
    try {
      _socket.write(com);
    } catch (e) {
      print("EX" + e.ToString());
    } finally {}
  }
}
