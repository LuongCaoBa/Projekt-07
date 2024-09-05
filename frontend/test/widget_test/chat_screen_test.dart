import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/funktion/message2.dart';
import 'package:namer_app/widget/chat_screen.dart';
import 'package:namer_app/widget/login_screen.dart';
import 'package:namer_app/funktion/loginfunktion.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:io';
import 'package:namer_app/widget/home_screen.dart';
import 'package:namer_app/widget/registration_screen.dart';
import 'package:namer_app/funktion/getmessage.dart';
import 'chat_screen_test.mocks.dart';

@GenerateMocks([http.Client])

void main() {

  setUpAll(() {
    // Replace the default HttpClient with a real one
    // Note: This should be done in setUpAll to ensure it happens before any tests run
    HttpOverrides.global = MyHttpClientOverrides();
  });

  tearDownAll(() {
    // Reset the HttpClient to the default implementation after all tests are done
    HttpOverrides.global = null;
  });

  testWidgets('Load with 2 messages', (WidgetTester tester) async { 
    // Create a mock http.Client
    final mockClient = MockClient();
    when(mockClient.get(Uri.parse("http://127.0.0.1:8080/messages?destID=1&Chunk-ID=0&User-ID=-1"), headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{"Error-bool": false, "Messages": "[{"Message-Content":"{\"content\":\"HelloWorld!\"}","Message-Timestamp":"2024-1-15 19:29:29Z","Message-Sender":"name"},{"Message-Content":"{\"content\":\"HelloWorld2\"}","Message-Timestamp":"2024-1-15 19:29:43Z","Message-Sender":"name"}]"}', 200));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: ChatScreen(chatTitle: "name",chatId: 1, messageCore: MessageCore(client : mockClient)),
      ),
    );
    // Wait for the initial loading of messages to complete.
    await tester.pump();

    // Allow asynchronous operations to progress to the next frame.
    await tester.pump(Duration.zero);

    // Wait for the FutureBuilder to complete loading messages
    await tester.pump();

    // Ensure that the ListView and ListTiles are displayed
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));

    // Ensure that the content of ListTiles is displayed
    expect(find.text('HelloWorld!'), findsOneWidget);
    expect(find.text('HelloWorld2'), findsOneWidget);
  });

  testWidgets('Load with 0 messages', (WidgetTester tester) async { 
    // Create a mock http.Client
    final mockClient = MockClient();
    when(mockClient.get(Uri.parse("http://127.0.0.1:8080/messages?destID=1&Chunk-ID=0&User-ID=-1"), headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{"Error-bool": false, "Messages": "[]"}', 200));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: ChatScreen(chatTitle: "name",chatId: 1, messageCore: MessageCore(client : mockClient)),
      ),
    );
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      int widgetCount = 0;
      tester.allWidgets.forEach((element) {
        if(element is ListTile){
          widgetCount++;
        }
      });
      expect(widgetCount, 0);
  });

  testWidgets('Send a Message', (WidgetTester tester) async { 
    // Create a mock http.Client
    final mockClient = MockClient();
    when(mockClient.get(Uri.parse("http://127.0.0.1:8080/messages?destID=1&Chunk-ID=0&User-ID=-1"), headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{"Error-bool": false, "Messages": "[]"}', 200));
    when(mockClient.post(Uri.parse("http://127.0.0.1:8080/messages/send?destID=1&ReleaseDate=0&Group=true&User-ID=-1"),headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('{"Error-bool": false, "Error-Messages": ""}', 200));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: ChatScreen(chatTitle: "name",chatId: 1, messageCore: MessageCore(client : mockClient)),
      ),
    );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'HelloWorld!');
      await tester.tap(find.byType(IconButton));

      final listView = find.byType(ListView);
      final listViewChildren = find.descendant(
        of: listView,
          matching: find.byType(ListTile),
        );
      expect(listViewChildren, 2);
  });
}



class MyHttpClientOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    // Customize other properties of HttpClient if needed
  }
}