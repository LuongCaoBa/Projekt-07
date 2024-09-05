import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:namer_app/backend/networkconection.dart' as networkconection;
import 'package:namer_app/backend/networkconection.dart';
import 'package:namer_app/backend/globals.dart' as globals;
import 'package:namer_app/funktion/loginfunktion.dart';
import 'package:tuple/tuple.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart' as prefs;
import 'login_test.mocks.dart';

// Mock classes
@GenerateMocks([networkconection.Backend])
@GenerateMocks([prefs.SharedPreferences])

void main(){
  Loginfunktion loginfunktion = Loginfunktion();
  group('login', () {
    test('Test: successfull login', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      final backend = MockBackend();
      final prefs = MockSharedPreferences();
      when(backend.sendMessage("", "Logger/login", requestType.GET, {"User-name": "test", "User-Password": "test"})).thenAnswer((_) => Future.value('{"Error-bool": false, "User-ID": 1, "User-Name": "test", "message": "login successfull"}'));
      when(backend.isError('{"Error-bool": false, "User-ID": 1, "User-Name": "test", "message": "login successfull"}')).thenReturn(false);
      when(prefs.setString("Username", "test")).thenAnswer((_) => Future.value(true));
      when(prefs.setString("password", "test")).thenAnswer((_) => Future.value(true));
      loginfunktion.setBackend(backend);
      loginfunktion.setprefs(prefs);
      Tuple2<bool, String> response = await loginfunktion.login("test", "test");
      expect(response, Tuple2(true, "Login erfolgreich"));
    });

    test('Test: successfull login server not Reachable', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      final backend = MockBackend();
      final prefs = MockSharedPreferences();
      when(backend.sendMessage("", "Logger/login", requestType.GET, {"User-name": "test", "User-Password": "test"})).thenAnswer((_) => Future.value('{"Error-Code": 404}'));
      when(backend.isError('{"Error-Code": 404}')).thenReturn(true);
      when(prefs.setString("Username", "test")).thenAnswer((_) => Future.value(true));
      when(prefs.setString("password", "test")).thenAnswer((_) => Future.value(true));
      loginfunktion.setBackend(backend);
      loginfunktion.setprefs(prefs);
      Tuple2<bool, String> response = await loginfunktion.login("test", "test");
      expect(response, Tuple2(false, "Login fehlgeschlagen"));
    });

    test('Test: invalid Login', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      final backend = MockBackend();
      final prefs = MockSharedPreferences();
      when(backend.sendMessage("", "Logger/login", requestType.GET, {"User-name": "test", "User-Password": "test"})).thenAnswer((_) => Future.value('{"Error-bool": true, "Error": "Wrong Password"}'));
      when(backend.isError('{"Error-bool": true, "Error": "Wrong Password"}')).thenReturn(false);
      when(prefs.setString("Username", "test")).thenAnswer((_) => Future.value(true));
      when(prefs.setString("password", "test")).thenAnswer((_) => Future.value(true));
      loginfunktion.setBackend(backend);
      loginfunktion.setprefs(prefs);
      Tuple2<bool, String> response = await loginfunktion.login("test", "test");
      expect(response, Tuple2(false, "Wrong Password"));
    });

    test('Test: already logged in', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      final backend = MockBackend();
      final prefs = MockSharedPreferences();
      when(backend.sendMessage("", "Logger/login", requestType.GET, {"User-name": "test", "User-Password": "test"})).thenAnswer((_) => Future.value('{"Error-bool": false, "User-ID": 1, "User-Name": "test", "message": "login successfull"}'));
      when(backend.isError('{"Error-bool": false, "User-ID": 1, "User-Name": "test", "message": "login successfull"}')).thenReturn(false);
      when(prefs.setString("Username", "test")).thenAnswer((_) => Future.value(true));
      when(prefs.setString("password", "test")).thenAnswer((_) => Future.value(true));
      loginfunktion.setBackend(backend);
      loginfunktion.setprefs(prefs);
      Tuple2<bool, String> response = await loginfunktion.login("test", "test");
      expect(response, Tuple2(true, "Login erfolgreich"));
      response = await loginfunktion.login("test", "test");
      expect(response, Tuple2(false, "Bereits eingeloggt"));
    });
  });

}