import 'package:flutter/material.dart';

class Global {
  static String ip = "0.0.0.0";
  static String status = "ON";
  static int tab = 0;

  static getHeight(context) => MediaQuery.of(context).size.height;
  static getWidth(context) => MediaQuery.of(context).size.width;
}
