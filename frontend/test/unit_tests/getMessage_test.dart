import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:namer_app/funktion/getmessage.dart';
import 'package:namer_app/funktion/message2.dart';
//import 'package:test/test.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:namer_app/model/Message.dart';
import 'package:tuple/tuple.dart' as custom_tuple;

import 'package:namer_app/backend/networkconection.dart' as networkconection;
import 'package:namer_app/backend/networkconection.dart';
import 'package:tuple/tuple.dart';
import 'addValueToSF_test.mocks.dart';


@GenerateMocks([networkconection.Backend])

void main() {
  GetMessage getMessage = GetMessage();

  void main() {
  // ...

  group('GetMessageByID Tests', () {
    test('GetMessageByID - Successful', () async {
      final mockBackend = MockBackend();

      // Definiere das erwartete Verhalten für sendMessage-Methode
      when(mockBackend.sendMessage("", "messages", requestType.GET, {"destID": 1, "Chunk-ID": 1}))
          .thenAnswer((_) async => '{"Error-bool": false, "Messages": []}');

      // Definiere das erwartete Verhalten für isError-Methode
      when(mockBackend.isError('{"Error-bool": false, "Messages": []}')).thenReturn(false);

      // Verwende das Mock-Backend in der MessageCore-Instanz
      MessageCore messageCore = MessageCore(backend: mockBackend);

      // Führe die GetMessageByID-Funktion mit beliebigen Parametern aus
      Tuple3<bool, String, List<message2>> result = await messageCore.GetMessageByID(1, 2);

      // Überprüfe, ob das erwartete Ergebnis zurückgegeben wurde
      expect(result.item1, true);
      expect(result.item2, 'Nachrichten erfolgreich geladen');
      expect(result.item3, isA<List<message2>>());

      // Überprüfe, ob die sendMessage-Methode wie erwartet aufgerufen wurde
      verify(await mockBackend.sendMessage("", "messages", requestType.GET, {"destID": 1, "Chunk-ID": 2})).called(1);
    });

    // Füge mehr Tests hinzu, um verschiedene Szenarien und Fehlerfälle abzudecken
  });


}}