import 'package:flutter/material.dart';
import 'package:namer_app/funktion/getmessage.dart';
import 'package:namer_app/model/Message.dart'; // Import der getmessage-Datei
import 'package:namer_app/funktion/message2.dart';
class ChatScreen extends StatefulWidget {
  final String chatTitle;
  final int chatId; // Annahme, dass die Chat-ID benötigt wird

  ChatScreen({required this.chatTitle, required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<message2> messages = []; // Verwenden Sie den Nachrichtentyp aus der "getmessage.dart"-Datei
  TextEditingController messageController = TextEditingController();

  // Funktion zum Laden der Nachrichten
  void loadMessages() async {
    var result = await MessageCore().GetMessageByID(widget.chatId, 0);
    if (result.item1) {
      setState(() {
        messages = result.item3.cast<message2>();
      });
    } else {
      // Fehlerbehandlung, z.B. Anzeige einer Fehlermeldung
      print("Fehler beim Laden der Nachrichten: ${result.item2}");
    }
  }

  // Funktion zum Senden einer Nachricht
  void sendMessage() async {
    String newMessage = messageController.text;
    if (newMessage.isNotEmpty) {
      var result = await MessageCore().sendMessage(newMessage, DateTime.now(), widget.chatId, true);
      if (result.item1) {
        // Wenn das Senden erfolgreich war, lade die Nachrichten erneut, um die aktualisierte Liste anzuzeigen
        loadMessages();
        messageController.clear();
      } else {
        // Fehlerbehandlung, z.B. Anzeige einer Fehlermeldung
        print("Fehler beim Senden der Nachricht: ${result.item2}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Beim Initialisieren der Seite Nachrichten laden
    loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index].content),
                  subtitle: Text(messages[index].sender),
                  // Hier können Sie auch das Datum aus der Nachricht anzeigen: messages[index].timestamp
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
