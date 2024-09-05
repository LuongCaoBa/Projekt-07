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
  group('addValueToSF', () {
    test('Test: Successfull Add', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      final prefs = MockSharedPreferences();
      when(prefs.setString("Username", "test")).thenAnswer((_) => Future.value(true));
      loginfunktion.setprefs(prefs);
      bool? response = await loginfunktion.addValueToSF("Username", "test", 0);
      expect(response, true);
    });

    test('Test: Failed Add', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      final prefs = MockSharedPreferences();
      when(prefs.setString("Username", "test")).thenAnswer((_) => Future.value(false));
      loginfunktion.setprefs(prefs);
      bool? response = await loginfunktion.addValueToSF("Username", "test", 0);
      expect(response, false);
    });

    test('Test: prefs not Reachable', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      bool? response = await loginfunktion.addValueToSF("Username", "test", 0);
      expect(response, null);
    });    

    test('Test: Invalid Type', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      final prefs = MockSharedPreferences();
      when(prefs.setString("Username", "test")).thenAnswer((_) => Future.value(false));
      loginfunktion.setprefs(prefs);
      bool? response = await loginfunktion.addValueToSF("Username", "test", 3);
      expect(response, false);
    });
  });
}