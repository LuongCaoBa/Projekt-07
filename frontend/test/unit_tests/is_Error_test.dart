
import 'dart:convert';

import 'package:namer_app/backend/networkconection.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'is_Error_test.mocks.dart';

const _backend = "http://127.0.0.1:8080/items";

// Generiere Mock-Objekt für http.Client.
@GenerateMocks([http.Client])
void main() {
  Backend backend = Backend();
  group('is Error', () {
    test('Test: gibt true zurück, falls respones JSON object mit Error code.', () {
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
              .get(Uri.parse(_backend)))
          .thenAnswer((_) async => http.Response('Not Found', 404));
          backend.setHttp(client);
          Map error ={
            'Error-Code': 404
          };

      expect(backend.isError(json.encode(error)), true);
    });
    test('Test: gibt false zurück wenn JSON object kein error code.', () async {
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
              .get(Uri.parse(_backend)))
          .thenAnswer((_) async =>
              http.Response('/', 200));
              backend.setHttp(client);
              Map response = {
                'key': 'value'
              };
      
      expect(backend.isError(json.encode(response)), false);
    });
    test('Test: gibt false zurück wenn kein JSON object.', () async {
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
              .get(Uri.parse(_backend)))
          .thenAnswer((_) async =>
              http.Response('[]', 200));
              backend.setHttp(client);

      expect(backend.isError("true"), false);
    });
  });
}

