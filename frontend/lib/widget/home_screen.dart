import 'package:flutter/material.dart';
import 'package:namer_app/funktion/groupmanager.dart';
import 'chat_screen.dart';
import 'package:namer_app/funktion/message2.dart';
import 'package:namer_app/funktion/getmessage.dart';
//import 'message_core.dart';
import 'package:tuple/tuple.dart';
import 'package:namer_app/backend/globals.dart' as globals;
import 'create_group_screen.dart';
import 'groupmanager_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  late MessageCore _messageCore;

  @override
  void initState() {
    super.initState();
    _messageCore = MessageCore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Willkommen, ${widget.username}!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder<Tuple3<bool, String, List<Tuple2<String, int>>>>(
            future: _messageCore.GetGroups(globals.userID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Fehler beim Laden der Chats: ${snapshot.error}');
              } else if (!snapshot.data!.item1) {
                return Text('Fehler: ${snapshot.data!.item2}');
              } else {
                List<Tuple2<String, int>> chats = snapshot.data!.item3;
                return Expanded(
                  child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(chats[index].item1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(chatTitle: chats[index].item1, chatId: chats[index].item2,),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyChatApp(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
