import 'package:flutter/material.dart';
import 'package:namer_app/funktion/loginfunktion.dart';
import 'home_screen.dart';
import 'package:tuple/tuple.dart';
class RegistrationScreen extends StatefulWidget {
  Loginfunktion loginfunktion = Loginfunktion();
  RegistrationScreen(){}
  RegistrationScreen.withLoginFunktion(this.loginfunktion);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState(loginfunktion);
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _studyProgramController = TextEditingController();
  TextEditingController _semesterController = TextEditingController();
  Loginfunktion _loginfunktion = Loginfunktion();
  _RegistrationScreenState(Loginfunktion loginfunktion){
    _loginfunktion = loginfunktion;
  }

  void _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;
    String studyProgram = _studyProgramController.text;
    int semester = int.tryParse(_semesterController.text) ?? 0; // Versuche, den Text in eine Ganzzahl zu konvertieren

    Tuple2<bool, String> registerResult =
        await _loginfunktion.register(username, password, email, studyProgram, semester);

    if (registerResult.item1) {
      // Erfolgreich registriert, zeige Bestätigungsnachricht an
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registrierung erfolgreich'),
          content: Text('Sie können sich jetzt anmelden.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Schließe die Bestätigungsnachricht
                Navigator.pop(context); // Gehe zurück zur vorherigen Seite (LoginScreen)
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Registrierung fehlgeschlagen, zeige Fehlermeldung an
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registrierung fehlgeschlagen'),
          content: Text(registerResult.item2),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Schließe die Fehlermeldung
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _studyProgramController,
              decoration: InputDecoration(labelText: 'Study Program'),
            ),
            TextField(
              controller: _semesterController,
              decoration: InputDecoration(labelText: 'Semester'),
              // String
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
} 
