import 'package:namer_app/backend/globals.dart';
import 'package:namer_app/model/Group.dart';
import 'dart:io';
import 'package:tuple/tuple.dart';
import 'package:namer_app/backend/networkconection.dart';
import 'dart:convert';
import 'package:namer_app/backend/globals.dart' as globals;


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:namer_app/model/User.dart';


class GroupManagerFunktion {
  // use IP 10.0.2.2 to access localhost from windows client 
  static const _backend = "http://127.0.0.1:8080/";
  
  // use IP 10.0.2.2 to access localhost from emulator! 
  // static const _backend = "http://10.0.2.2:8080/";

  // get Groups list from backend
  Future<List<Group>> fetchGroupList(http.Client client) async {

     // access REST interface with get request
    final response = await client.get(Uri.parse('${_backend}groups'));

    // check response from backend
    if (response.statusCode == 200) {
      print('Data from API:');
      return List<Group>.from(json.decode(utf8.decode(response.bodyBytes)).map((x) => Group.fromJson(x)));
    } else {
      throw Exception('Failed to load Grouplist');
    }
  }

  // get Groups from backend
  Future<Group> fetchGroup(http.Client client, int groupId) async {

     // access REST interface with get request
    final response = await client.get(Uri.parse('${_backend}groups/$groupId'));

    // check response from backend
    if (response.statusCode == 200) {
      return Group.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load Group');
    }
  }

  // save new group on backend
  Future<Group> createGroup(http.Client client, String name) async {
  Map data = {
    'name': name,
  };

  var response = await client.post(
    Uri.parse('${_backend}groups'),
    headers: <String, String>{'Content-Type': 'application/json'},
    body: json.encode(data),
  );

  if (response.statusCode == 200) {
    Group newGroup = Group.fromJson(json.decode(utf8.decode(response.bodyBytes)));

    // Hier rufst du die Funktion zum Hinzufügen des Benutzers zur Gruppe auf
    await addUserToGroup(client, newGroup.id, globals.userID);

    return newGroup;
  } else {
    throw Exception('Failed to create group');
  }
}

// Funktion zum Hinzufügen des Benutzers zur Gruppe
Future<void> addUserToGroup(http.Client client, int groupId, int userId) async {
  Map data = {
    'userId': userId,
  };

  var response = await client.put(
    Uri.parse('${_backend}groups/$groupId/addUser/$userId'),
    headers: <String, String>{'Content-Type': 'application/json'},
    body: json.encode(data),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to add user to group');
  }
}


  Future<void> deleteGroup(http.Client client, int groupId) async {
    final response = await client.delete(Uri.parse('${_backend}groups/$groupId'),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to delete item');
    }
  }

  Future<Group> updateGroup(http.Client client, int groupId, String name) async {
    final data = {
      'name': name,
    };

    final response = await client.put(Uri.parse('${_backend}groups/$groupId'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return Group.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update item. Unexpected status code: ${response.statusCode}');
    }
  }

    // get Users list in Group with Id from backend
  Future<List<User>> fetchUserList(http.Client client, int groupId) async {

     // access REST interface with get request
    final response = await client.get(Uri.parse('${_backend}groups/$groupId/users'));

    // check response from backend
    if (response.statusCode == 200) {
      return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((x) => User.fromJson(x)));
    } else {
      throw Exception('Failed to load Userlist');
    }
  }
  

Future<Group> deleteUserFromGroup(http.Client client, int groupId, int userId) async {
  final response = await client.put(Uri.parse('${_backend}groups/$groupId/users/$userId'),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Group.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to add user. Unexpected status code: ${response.statusCode}');
    }
  }

  Future<List<User>> fetchUserListNotInGroup(http.Client client, int groupId) async {

     // access REST interface with get request
    final response = await client.get(Uri.parse('${_backend}groups/$groupId/usersNotInGroup'));

    // check response from backend
    if (response.statusCode == 200) {
      return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((x) => User.fromJson(x)));
    } else {
      throw Exception('Failed to load Userlist');
    }
  }

  Future<List<Group>> fetchGroupListWithUserID(http.Client client,int userID) async {
     // access REST interface with get request
    final response = await client.get(Uri.parse('${_backend}users/$userID/groups'));

    // check response from backend
    if (response.statusCode == 200) {
      print('Data from API:');
      return List<Group>.from(json.decode(utf8.decode(response.bodyBytes)).map((x) => Group.fromJson(x)));
    } else {
      throw Exception('Failed to load Grouplist');
    }
  }
}
class groupmanager{

  Future<Tuple2<bool, String>> createAutoGroup(String studienGang, String CSVPath) async{

    File file = File(CSVPath);
    String csvContent = file.readAsStringSync();
    String out = await Backend().sendMessage(csvContent, "groups/create", requestType.POST, {"StudienGang": studienGang});
    if(Backend().isError(out)){
      return Tuple2(false, "Fehler beim Erstellen der Gruppen");
    }
    final answer = jsonDecode(out) as Map<String, dynamic>;
    if(answer["Error-bool"] == true){
      return Tuple2(false, answer["Error-Message"]);
    }
    return Tuple2(true, "Gruppen erfolgreich erstellt");
  }
}