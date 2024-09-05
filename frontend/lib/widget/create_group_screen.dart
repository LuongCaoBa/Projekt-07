import 'package:flutter/material.dart';
import 'package:namer_app/funktion/groupmanager.dart';
import 'package:http/http.dart' as http;
class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  TextEditingController _groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neue Gruppe erstellen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(labelText: 'Gruppenname'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String groupName = _groupNameController.text;
                if (groupName.isNotEmpty) {
                  bool success = await _saveGroupToBackend(groupName);
                  if (success) {
                    Navigator.pop(context); // Zurück zur vorherigen Seite
                  } else {
                    // Handle Fehler
                  }
                } else {
                  // Zeige eine Meldung an, dass der Gruppenname erforderlich ist
                }
              },
              child: Text('Erstellen'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _saveGroupToBackend(String groupName) async {
    try {
      // Hier rufst du die entsprechende Funktion aus der GroupManagerFunktion-Klasse auf
      // um die Gruppe im Backend zu erstellen
      await GroupManagerFunktion().createGroup(http.Client(), groupName);
      return true;
    } catch (e) {
      print('Fehler beim Erstellen der Gruppe: $e');
      return false;
    }
  }
}
