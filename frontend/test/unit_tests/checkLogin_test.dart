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
  group('checkLogin', () {
    test('Test: checkLogin False', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      globals.loggedIn = false;
      bool response = loginfunktion.checkLogin();
      expect(response, false);
    });

    test('Test: checkLogin True', () async{
      TestWidgetsFlutterBinding.ensureInitialized();
      globals.loggedIn = true;
      bool response = loginfunktion.checkLogin();
      expect(response, true);
    });
  });
}