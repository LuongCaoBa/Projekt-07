import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/widget/login_screen.dart';
import 'package:namer_app/widget/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/widget/registration_screen.dart';
import 'package:namer_app/widget/groupmanager_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  testWidgets('Login Screen Test', (WidgetTester tester) async {
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Find the text fields and buttons
    final emailField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).last;
    final loginButton = find.byType(ElevatedButton);

    // Enter valid login credentials
    await tester.enterText(emailField, 'example@example.com');  //Hier bitte eine Email, die schon angemeldet ist
    await tester.enterText(passwordField, '1234');
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 2));
    // Tap the login button
    await tester.tap(loginButton);

    // Wait for the UI to settle
    await tester.pumpAndSettle(Duration(seconds: 2));

    // Verify that the HomeScreen is pushed onto the navigation stack
    expect(find.byType(HomeScreen), findsOneWidget);

   
  });
  testWidgets('Login Screen Test fail', (WidgetTester tester) async {
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Find the text fields and buttons
    final emailField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).last;
    final loginButton = find.byType(ElevatedButton);

    // Enter valid login credentials
    await tester.enterText(emailField, 'test.test@gmail.com');
    await tester.enterText(passwordField, '2342');
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 2));
    // Tap the login button
    await tester.tap(loginButton);

    // Wait for the UI to settle
    await tester.pumpAndSettle(Duration(seconds: 2));

    // Verify that the HomeScreen is pushed onto the navigation stack
    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.pumpAndSettle(Duration(seconds: 2));
  });
   testWidgets('Registration and Navigate to Home Screen Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: RegistrationScreen()));

    // Find the text fields and button
    final usernameField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final emailField = find.byType(TextField).at(2);
    final studyProgramField = find.byType(TextField).at(3);
    final semesterField = find.byType(TextField).at(4);
    final registerButton = find.byType(ElevatedButton);

    // Enter valid registration information
    await tester.enterText(usernameField, 'Ravi');
    await tester.enterText(passwordField, '1234');
    await tester.enterText(emailField, 'test@test.de'); // Hier bitte eine Email verwenden, die noch nicht angemeldet ist!
    await tester.enterText(studyProgramField, 'IT');
    await tester.enterText(semesterField, '3');

    await tester.pumpAndSettle(Duration(seconds: 2));

    // Tap the register button
    await tester.tap((registerButton));

    // Wait for the UI to settle
    await tester.pumpAndSettle(Duration(seconds: 2));

    // Verify that the HomeScreen is pushed onto the navigation stack
    await tester.tap(find.byType(TextButton));

    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 2));
    expect(find.byType(LoginScreen), findsOneWidget);

    // You can add more test cases related to HomeScreen here
  });
  testWidgets('Registration and Navigate to Home Screen Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: RegistrationScreen()));

    // Find the text fields and button
    final usernameField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final emailField = find.byType(TextField).at(2);
    final studyProgramField = find.byType(TextField).at(3);
    final semesterField = find.byType(TextField).at(4);
    final registerButton = find.byType(ElevatedButton);

    // Enter valid registration information
    await tester.enterText(usernameField, 'testfail');
    await tester.enterText(passwordField, '1234');
    await tester.enterText(emailField, '');
    await tester.enterText(studyProgramField, 'IT');
    await tester.enterText(semesterField, '3');

    await tester.pumpAndSettle(Duration(seconds: 2));

    // Tap the register button
    await tester.tap((registerButton));

    // Wait for the UI to settle
    await tester.pumpAndSettle(Duration(seconds: 2));

    // Verify that the HomeScreen is pushed onto the navigation stack
    await tester.tap(find.byType(TextButton));

    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 2));
    expect(find.byType(RegistrationScreen), findsOneWidget);

    // You can add more test cases related to HomeScreen here
  });
  testWidgets('Home Screen Test 1', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: HomeScreen(username: 'test')));

    await tester.pumpAndSettle(Duration(seconds: 2));

    // Tap the register button
   
    //expect(find.byType(HomeScreen), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(Duration(seconds: 2));

    expect(find.byType(MainPage), findsOneWidget);
  });
}