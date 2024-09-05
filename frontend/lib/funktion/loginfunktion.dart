
import 'dart:convert';
import 'dart:io';
import 'package:tuple/tuple.dart';
import 'package:namer_app/backend/networkconection.dart';
import 'package:namer_app/backend/globals.dart' as globals;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Loginfunktion{
  Backend backend = Backend();
  SharedPreferences? prefs = null;

  Loginfunktion({http.Client? client}){
    backend = Backend(client : client);
    prefsini();
  }

  Future<Tuple2<bool, String>> login(String email, String password) async{
    if(checkLogin()){
      return Tuple2(false, "Bereits eingeloggt");
    }
    String out = "";
     out = await backend.sendMessage("", "Logger/login", requestType.GET, {"User-name": email, "User-Password": password});
    if(backend.isError(out)){
      return Tuple2(false, "Login fehlgeschlagen");
    }
    final answer = jsonDecode(out) as Map<String, dynamic>;
    if(answer["Error-bool"] == true){
      return Tuple2(false, answer["Error"]);
    }
    globals.userID = answer["User-ID"];
    globals.username = answer["User-Name"];
    globals.loggedIn = true;
    addValueToSF("Username", email, 0);
    addValueToSF("password", password, 0);
    return Tuple2(true, "Login erfolgreich");
  }

  bool checkLogin(){
    if(globals.loggedIn){
      return true;
    }
    return false;
  }  

  Future<bool> logout() async{
    if(!checkLogin()){
      return false;
    }
    String response = "";
    response = await backend.sendMessage("", "Logger/logout", requestType.GET, Map());
    if(backend.isError(response)){
      return false;
    }
    globals.userID = (-1) as int;
    globals.username = "";
    globals.loggedIn = false;
    addValueToSF("Username", "", 0);
    addValueToSF("password", "", 0);
    return true;
  }

  Future<Tuple2<bool, String>> register(String username, String password, String email, String studienGang, int semester) async{
    if(checkLogin()){
      return Tuple2(false, "Bereits eingeloggt");
    }
    Map<String, dynamic> body = {
      "User-name": username,
      "User-Password": password,
      "User-Email": email,
      "Studien-Gang": studienGang,
      "Semester": semester
    };
    String response = "";
    response = await backend.sendMessage(jsonEncode(body), "Logger/register", requestType.POST, Map());
    if(backend.isError(response)){
      return Tuple2(false, "Registrierung fehlgeschlagen");
    }
    final answer = jsonDecode(response) as Map<String, dynamic>;
    if(answer["Error-bool"] == true){
      return Tuple2(false, answer["Error"]);
    }
    //globals.userID = answer["User-ID"];
    //globals.username = answer["User-Name"];
    //globals.loggedIn = true;
    return Tuple2(true, "Registrierung erfolgreich");
  }

  Future<Tuple2<bool, String>> changePassword(String oldPassword, String newPassword)async{
    if(!checkLogin()){
      return Tuple2(false, "Nicht eingeloggt");
    }
    Map<String, dynamic> body = {
      "User-Password": oldPassword,
      "User-Password-Neu": newPassword
    };
    String response = "";
    response = await backend.sendMessage(jsonEncode(body), "Logger/changePassword", requestType.POST, Map());
    if(backend.isError(response)){
      return Tuple2(false, "Passwort ändern fehlgeschlagen");
    }
    final answer = jsonDecode(response) as Map<String, dynamic>;
    if(answer["Error-bool"] == true){
      return Tuple2(false, answer["Error"]);
    }
    return Tuple2(true, "Passwort ändern erfolgreich");
  }
/*
  Future<Tuple2<bool, String>> autoLogin() async{
    if(kIsWeb){
      return Tuple2(false, "Web-App");
    }
    if(checkLogin()){
      return Tuple2(false, "Bereits eingeloggt");
    }
    String email = "";
    String password = "";
    email = await getStringValuesSF("Username");
    password = await getStringValuesSF("password");
    if(email == "" || password == ""){
      return Tuple2(false, "Keine Daten gespeichert");
    }
    return login(email, password, client);
  }*/

  Future<bool?> addValueToSF(String key, dynamic value, int type) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (type) {
      case 0:
        return prefs?.setString(key, value);
      case 1:
        return prefs?.setInt(key, value);
      case 2:
        return prefs?.setBool(key, value);
    }
    return false;
  }

  Future<String> getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString(key);
    if(stringValue == null){
      return "";
    }
    return (stringValue);
  }

  Future<bool> getBoolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool? boolValue = prefs.getBool(key);
    if(boolValue == null){
      return false;
    }
    return boolValue;
  }

  Future<int> getIntValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int? intValue = prefs.getInt(key);
    if(intValue == null){
      return (-1);
    }
    return intValue;
  }

  void setBackend(Backend backend){
    this.backend = backend;
  }

  void setprefs(SharedPreferences prefs){
    this.prefs = prefs;
  }

  void prefsini()async{
    try{
      prefs = await SharedPreferences.getInstance();
    }catch(e){
      print(e);
    }
  }
}