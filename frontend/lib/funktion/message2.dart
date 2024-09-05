import 'dart:convert';
import 'package:tuple/tuple.dart';
import 'package:namer_app/backend/networkconection.dart';
import 'package:namer_app/backend/globals.dart' as globals;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:namer_app/funktion/message2.dart';

class message2{
  String content;
  String sender;
  DateTime timestamp;
  message2(this.content, this.sender, this.timestamp);
}