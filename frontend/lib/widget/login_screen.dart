import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'registration_screen.dart';
import 'home_screen.dart';
import 'package:namer_app/funktion/loginfunktion.dart';
import 'package:namer_app/backend/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  
  Loginfunktion loginfunktion = Loginfunktion();
  LoginScreen(){}
  LoginScreen.withLoginFunktion(this.loginfunktion);
  @override
  _LoginScreenState createState() => _LoginScreenState(loginfunktion);
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Loginfunktion _loginFunction = Loginfunktion();
 
  _LoginScreenState(Loginfunktion loginfunktion) {
    _loginFunction = loginfunktion;
  }

  void _login() async {
    // Holen Sie sich die eingegebenen Anmeldeinformationen
    String email = _emailController.text;
    String password = _passwordController.text;

    // Verwenden Sie die LoginFunction, um den Login zu überprüfen
    Tuple2<bool, String> loginResult = await _loginFunction.login(email, password);

    if (loginResult.item1) {
      // Login erfolgreich, gehe zum HomeScreen und übergebe den Benutzernamen
      String username = globals.username;
      Navigator.pushReplacement(
        context,
          MaterialPageRoute(builder: (context) => HomeScreen(username: username)),
      );
    } else {
      // Zeige eine Fehlermeldung an oder handle den fehlgeschlagenen Login auf andere Weise.
      // Beispiel: Zeige ein SnackBar mit der Fehlermeldung an.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login fehlgeschlagen: ${loginResult.item2}'),
        ),
      );
    }
  }

  void _goToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: _goToRegistration,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
