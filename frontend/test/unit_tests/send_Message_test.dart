
import 'dart:convert';

import 'package:namer_app/backend/networkconection.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'send_Message_test.mocks.dart';

const _backend = "http://127.0.0.1:8080/";

// Generiere Mock-Objekt für http.Client.
@GenerateMocks([http.Client])
void main() {
  Backend backend = Backend();
  group('Test: send_Message', () {
    test('Test: gibt Error als JSON object zurück, falls Http Aufruf mit Fehler 404 endet.', () async{
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
             .get(Uri.parse(_backend + "/?User-ID=-1"),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
          backend.setHttp(client);

      String result = await backend.sendMessage("message", "/", requestType.GET, Map());
      Map<String, dynamic> error = json.decode(result);
      expect(error.containsKey("Error-Code"), true);
      expect(error.containsValue(404), true);
    });
    test('Test: Send Message with String response', () async {
    final client = MockClient();

    // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
    when(client
            .get(Uri.parse(_backend + "/?User-ID=-1"),
            headers: anyNamed('headers')))
        .thenAnswer((_) async =>
            http.Response("true", 200));
            backend.setHttp(client);

        String result = await backend.sendMessage("message", "/", requestType.GET, Map());
        expect(result, "true");
      });

    test('Test: Send Message with Map response', () async {
    final client = MockClient();

    // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
    when(client
            .get(Uri.parse(_backend + "/?User-ID=-1"),
            headers: anyNamed('headers')))
        .thenAnswer((_) async =>
            http.Response("{'key': 'value'}", 200));
            backend.setHttp(client);

        String result = await backend.sendMessage("message", "/", requestType.GET, Map());
        expect(result, "{'key': 'value'}");
      });

    test('Test: has additional query Params', () async {
    final client = MockClient();

    when(client
            .get(Uri.parse(_backend + "/?Name=1&User-ID=-1"),
            headers: anyNamed('headers')))
        .thenAnswer((_) async =>
            http.Response("[1, 2, 3]", 200));
            backend.setHttp(client);

        String result = await backend.sendMessage("message", "/", requestType.GET, {'Name': '1'});
        expect(result, "[1, 2, 3]");
      });
  });
}

