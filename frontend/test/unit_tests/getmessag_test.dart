import 'dart:convert';
import 'package:tuple/tuple.dart';
import 'package:namer_app/backend/networkconection.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'getmessag_test.mocks.dart';
import 'package:namer_app/funktion/getmessage.dart';
import 'package:namer_app/funktion/message2.dart';
const _backend = "http://127.0.0.1:8080/";

// Generiere Mock-Objekt für http.Client.
@GenerateMocks([http.Client])
void main() {
  group('Test: allMessages', () {
    test('Test: gibt Error als JSON object zurück, falls Http Aufruf mit Fehler 404 endet.', () async{
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
             .get(Uri.parse(_backend + "messages/?destID=1&Chunk-ID=0&User-ID=-1"),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
          
          MessageCore messageCore = MessageCore(backend: Backend(client: client));

      Tuple3<bool, String, List<message2>> result = await messageCore.GetMessageByID(1,0);
      expect(result.item1, false);
      expect(result.item2, "Fehler beim Laden der Nachrichten");
    });
    test('Test: Invalide Gruppen Id', () async{
      final client = MockClient();
      final map = {
        "Error-bool": true,
        "Error-Message": "Gruppen ID nicht gefunden"
      };
      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
             .get(Uri.parse(_backend + "messages/?destID=5&Chunk-ID=0&User-ID=-1"),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode(map), 200));
          MessageCore messageCore = MessageCore(backend: Backend(client: client));

      Tuple3<bool, String, List<message2>> result = await messageCore.GetMessageByID(5,0);
      expect(result.item1, false);
      expect(result.item2, "Gruppen ID nicht gefunden");
    });

    test('Test: Keine Narichten Abzuholen', () async{
      final client = MockClient();
      final map = {
        "Error-bool": false,
        "Error-Message": "",
        "Messages": []
      };
      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
             .get(Uri.parse(_backend + "messages/?destID=1&Chunk-ID=0&User-ID=-1"),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode(map), 200));
          MessageCore messageCore = MessageCore(backend: Backend(client: client));

      Tuple3<bool, String, List<message2>> result = await messageCore.GetMessageByID(1,0);
      expect(result.item1, true);
      expect(result.item2, "Nachrichten erfolgreich geladen");
    });

    test('Test: Get Messages', () async{
      final client = MockClient();
      final map1 = {
        "Message-Content": "Hello World",

      };
      final map = {
        "Error-bool": false,
        "Error-Message": "",
        "Messages": []
      };
      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
             .get(Uri.parse(_backend + "messages/?destID=1&Chunk-ID=0&User-ID=-1"),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('{"Error-bool": false, "Messages": "[{"Message-Content":"{\"content\":\"HelloWorld!\"}","Message-Timestamp":"2024-1-15 19:29:29Z","Message-Sender":"name"},{"Message-Content":"{\"content\":\"HelloWorld2\"}","Message-Timestamp":"2024-1-15 19:29:43Z","Message-Sender":"name"}]"}', 200));
          MessageCore messageCore = MessageCore(backend: Backend(client: client));

      Tuple3<bool, String, List<message2>> result = await messageCore.GetMessageByID(1,0);
      expect(result.item1, true);
      expect(result.item2, "Nachrichten erfolgreich geladen");
    });
  });
}