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
  group('register', () {
    test('Test: Succsessfull Registration', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      final backend = MockBackend();
      final prefs = MockSharedPreferences();
      Map<String, dynamic> body = {
      "User-name": "Test",
      "User-Password": "Test",
      "User-Email": "Test@Test.com",
      "Studien-Gang": "Informatik",
      "Semester": 1
      };

      when(backend.sendMessage(jsonEncode(body), "Logger/register", requestType.POST, Map())).thenAnswer((_) => Future.value('{"Error-bool": false, "Error": "Registration successfull"}'));
      when(backend.isError('{"Error-bool": false, "Error": "Registration successfull"}')).thenReturn(false);
      loginfunktion.setBackend(backend);
      loginfunktion.setprefs(prefs);
      Tuple2<bool, String> response = await loginfunktion.register("Test", "Test", "Test@Test.com", "Informatik", 1);
      expect(response, Tuple2(true, "Registrierung erfolgreich"));
    });

    test('Test: Server not Reachable', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      final backend = MockBackend();
      final prefs = MockSharedPreferences();
      Map<String, dynamic> body = {
      "User-name": "Test",
      "User-Password": "Test",
      "User-Email": "Test2@Test.com",
      "Studien-Gang": "Informatik",
      "Semester": 1
      };

      when(backend.sendMessage(jsonEncode(body), "Logger/register", requestType.POST, Map())).thenAnswer((_) => Future.value('{"Error-Code": 404}'));
      when(backend.isError('{"Error-Code": 404}')).thenReturn(true);
      loginfunktion.setBackend(backend);
      loginfunktion.setprefs(prefs);
      Tuple2<bool, String> response = await loginfunktion.register("Test", "Test", "Test2@Test.com", "Informatik", 1);
      expect(response, Tuple2(false, "Registrierung fehlgeschlagen"));
    });

    test('Test: invalid Registration', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      final backend = MockBackend();
      final prefs = MockSharedPreferences();
      Map<String, dynamic> body = {
      "User-name": "Test",
      "User-Password": "Test",
      "User-Email": "Test3@Test.com",
      "Studien-Gang": "Informatik",
      "Semester": 1
      };

      when(backend.sendMessage(jsonEncode(body), "Logger/register", requestType.POST, Map())).thenAnswer((_) => Future.value('{"Error-bool": true, "Error": "User already exists"}'));
      when(backend.isError('{"Error-bool": true, "Error": "User already exists"}')).thenReturn(false);
      loginfunktion.setBackend(backend);
      loginfunktion.setprefs(prefs);
      Tuple2<bool, String> response = await loginfunktion.register("Test", "Test", "Test3@Test.com", "Informatik", 1);
      expect(response, Tuple2(false, "User already exists"));
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
      response = await loginfunktion.register("Test", "Test", "Test4@Test.com", "Informatik", 1);
      expect(response, Tuple2(false, "Bereits eingeloggt"));
    });
  });
}