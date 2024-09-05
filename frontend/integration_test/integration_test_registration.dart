import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/widget/login_screen.dart';
import 'package:namer_app/widget/registration_screen.dart'; // Achte darauf, den richtigen Import zu verwenden
import 'package:namer_app/widget/home_screen.dart'; // Achte darauf, den richtigen Import zu verwenden
import 'package:namer_app/widget/login_screen.dart';
void main() {
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
    await tester.enterText(emailField, 'raphael.bannert@gmail.com');
    await tester.enterText(studyProgramField, 'IT');
    await tester.enterText(semesterField, '3');

    await tester.pumpAndSettle(Duration(seconds: 2));

    // Tap the register button
    await tester.tap((registerButton));

    // Wait for the UI to settle
    await tester.pumpAndSettle(Duration(seconds: 2));

    // Verify that the HomeScreen is pushed onto the navigation stack
    expect(find.byType(LoginScreen), findsOneWidget);

    // You can add more test cases related to HomeScreen here
  });
}