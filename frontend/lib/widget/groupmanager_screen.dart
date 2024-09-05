import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/funktion/groupmanager.dart';
import 'package:namer_app/model/Group.dart';
import 'package:namer_app/widget/group_details_screen.dart';
import 'package:namer_app/widget/home_screen.dart';
import 'package:namer_app/funktion/loginfunktion.dart';
import 'package:namer_app/backend/globals.dart' as globals;
//void main() {
//  runApp(MyChatApp());
//}



class MyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(GroupManagerFunktion(), http.Client()),
    );
  }
}

// widget class to create stateful item list view page
class MainPage extends StatefulWidget {

  final GroupManagerFunktion _backend;
  final http.Client _client;
  
  const MainPage(this._backend, this._client);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  // necessary for mocking (unit and widget tests)
  late GroupManagerFunktion _backend;    // library with functions to access backend
  late http.Client _client; // REST client proxy
  Loginfunktion _loginFunction = Loginfunktion();
  @override
  void initState() {
    super.initState();
    _backend = widget._backend;
    _client = widget._client;
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Implement the action for the profile here
            },
          ),
        ],
      ),
              body: FutureBuilder<List<Group>>(
                future:  _backend.fetchGroupListWithUserID(http.Client(),globals.userID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                    // do something till waiting for data, we can show here a loader
                  } else if (snapshot.hasData) {
                    
                    // we have the data, do stuff here
                  } else {
                    return const Text("No data available");
                    // we did not recieve any data, maybe show error or no data available
                  }
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (_, int position) {
                            final item = snapshot.data?[position];
                            return Card(
                              child: ListTile(
                                title: Text(item!.name),
                                trailing: Row(          
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                  IconButton(
                                    key: Key("delete"),
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Delete Group',
                                    onPressed: () async {
                                      await _backend.deleteGroup(http.Client(), item.id);

                                      // Refresh the UI after deleting the group
                                      setState(() {});
                                    },
                                  ),
                                  IconButton(
                                    key: Key("info"),
                                    icon: const Icon(Icons.info),
                                    tooltip: 'Group Information',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GroupDetailsScreen(
                                            backend: _backend, // Replace with your GroupManagerFunktion instance
                                            client: http.Client(),
                                            groupId: item.id, // Pass the group ID you want to display details for
                                          ),
                                        ),
                                      ).whenComplete(() => setState(() {}));
                                    },
                                  ),
                                ]),
                              ),
                            );
                          },
                        ) : Center(
                          child: null
                        );
                },
            ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'New',
          onPressed: () async {
            // Declare groupName variable
            String? groupName;

            // Show a dialog to get the group name from the user
            groupName = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Enter Group Name'),
                  content: TextField(
                    onChanged: (value) => groupName = value,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(groupName);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );

            // Check if the user entered a group name
            if (groupName != null && groupName!.isNotEmpty) {
            
              // Create the new group using the backend function
              await _backend.createGroup(http.Client(), groupName!);

              // Refresh the UI or perform any other necessary actions
              setState(() {});
            }
          },
          child: Icon(Icons.add),
        ),


      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Benutzername',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.back_hand),
              title: Text('Back'),
              onTap: () async{
                String username = await _loginFunction.getStringValuesSF("Username");
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(username: username)));
                // Implement the action for settings
              },
            ),
          ],
        ),
      ),
    );
  }


}