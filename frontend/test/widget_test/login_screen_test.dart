import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/widget/login_screen.dart';
import 'package:namer_app/funktion/loginfunktion.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'login_screen_test.mocks.dart';
import 'package:mockito/mockito.dart';
import 'dart:io';
import 'package:namer_app/widget/home_screen.dart';
import 'package:namer_app/widget/registration_screen.dart';

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

  testWidgets('buttons and Text boxes found', (WidgetTester tester) async {
    // Create a mock http.Client
    final mockClient = MockClient();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen.withLoginFunktion(Loginfunktion(client : mockClient)),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);

    // You can set up expectations on your mockClient here if needed.
  });

  testWidgets('Login Screen UI Test', (WidgetTester tester) async {
    // Create a mock http.Client
    final mockClient = MockClient();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen.withLoginFunktion(Loginfunktion(client : mockClient)),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    expect(find.text('user@example.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);

    // You can set up expectations on your mockClient here if needed.
  });

  testWidgets('failed login stays at login', (WidgetTester tester) async { 
    // Create a mock http.Client
    final mockClient = MockClient();
    Map<String, String> content = {
      "Content-Type": "application/json"
    };
    when(mockClient.get(Uri.parse("http://127.0.0.1:8080/Logger/login?User-name=user%40example.com&User-Password=password123&User-ID=-1"), headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{"Error-bool": true, "Error": "Wrong Password"}', 200));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen.withLoginFunktion(Loginfunktion(client : mockClient)),
      ),
    );
      
      // Perform login action
      await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      
      // After successful login, HomeScreen should be pushed
      // Use a Key or other identifying feature to verify if HomeScreen is present
      expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Succssess login goes to home screen', (WidgetTester tester) async { 
    // Create a mock http.Client
    final mockClient = MockClient();
    Map<String, String> content = {
      "Content-Type": "application/json"
    };
    when(mockClient.get(Uri.parse("http://127.0.0.1:8080/Logger/login?User-name=user%40example.com&User-Password=password123&User-ID=-1"), headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{"Error-bool": false, "message": "login successfull", "User-ID": 1, "User-Name": "Hello"}', 200));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen.withLoginFunktion(Loginfunktion(client : mockClient)),
      ),
    );
      
      // Perform login action
      await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pump();
      
      // After successful login, HomeScreen should be pushed
      // Use a Key or other identifying feature to verify if HomeScreen is present
      expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Successfull Switch to Register', (WidgetTester tester) async { 
    // Create a mock http.Client
    final mockClient = MockClient();
    Map<String, String> content = {
      "Content-Type": "application/json"
    };
    when(mockClient.get(Uri.parse("http://127.0.0.1:8080/Logger/login?User-name=user%40example.com&User-Password=password123&User-ID=-1"), headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{"Error-bool": false, "message": "login successfull", "User-ID": 1, "User-Name": "Hello"}', 200));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen.withLoginFunktion(Loginfunktion(client : mockClient)),
      ),
    );
      
      // Perform login action
      await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.pump();
      
      // After successful login, HomeScreen should be pushed
      // Use a Key or other identifying feature to verify if HomeScreen is present
      expect(find.byType(RegistrationScreen), findsOneWidget);
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
