import 'dart:convert';
import 'package:tuple/tuple.dart';
import 'package:namer_app/backend/networkconection.dart';
import 'package:namer_app/funktion/message2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:namer_app/model/Message.dart';
import 'package:namer_app/backend/globals.dart' as globals;


class MessageCore{
  final Backend backend;

  MessageCore({Backend? backend}):backend = backend ?? Backend();
    
  
  Future<Tuple3<bool, String, List<message2>>> GetMessageByID(int id, int chunkid) async{
    List<message2> messages = [];
    String out = await backend.sendMessage("", "messages", requestType.GET, {"destID": id, "Chunk-ID": chunkid});
    if(backend.isError(out)){
      return Tuple3(false, "Fehler beim Laden der Nachrichten", messages);
    }
    final answer = jsonDecode(out) as Map<String, dynamic>;
    if(answer["Error-bool"] == true){
      return Tuple3(false, answer["Error-Message"], messages);
    }
    
    for(var i = 0; i < answer["Messages"].length; i++){
      messages.add(new message2(json.decode(answer["Messages"][i]["Message-Content"])["content"], answer["Messages"][i]["Message-Sender"], DateTime.now()));
    }
    return Tuple3(true, "Nachrichten erfolgreich geladen", messages);

  }

  Future<Tuple2<bool, String>> sendMessage(String MessageContent, DateTime visiblityTime, int id, bool isGroup) async{
    String OpenTime = visiblityTime.year.toString() + "-" + visiblityTime.month.toString() + "-" + visiblityTime.day.toString() + "-" + visiblityTime.hour.toString() + "-" + visiblityTime.minute.toString() + "-" + visiblityTime.second.toString();
    String out = await backend.sendMessage(MessageContent, "messages/send", requestType.POST, {"destID": id, "ReleaseDate": OpenTime, "Group": isGroup});
    if(backend.isError(out)){
      return Tuple2(false, "Fehler beim Senden der Nachricht");
    }
    final answer = jsonDecode(out) as Map<String, dynamic>;
    if(answer["Error-bool"] == true){
      return Tuple2(false, answer["Error-Message"]);
    }
    return Tuple2(true, "Nachricht erfolgreich gesendet");

  }

  Future<Tuple3<bool, String, List<Tuple2<String, int>>>> GetGroups(int id) async{
    List<Tuple2<String, int>> messages = [];
    int id = globals.userID;
    String out = await backend.sendMessage("", "users/" + id.toString() + "/group_list", requestType.GET, Map());
    if(backend.isError(out)){
      return Tuple3(false, "Fehler beim Laden der Guppen", messages);
    }
    //final answer = jsonDecode(out) as Map<String, dynamic>;
    //if(answer["Error-bool"] == true){
    //  return Tuple3(false, answer["Error-Message"], messages);
    //}
    if(out == ""){
      return Tuple3(false, "Keine Gruppen Gefunden", messages);
    }
    List<String> groups = out.split(",");
    
    for(var i = 0; i < groups.length-1; i++){
      messages.add(Tuple2(groups[i].split('.')[0],int.parse(groups[i].split(':')[1])));
    }
    return Tuple3(true, "Guppen Geladen", messages);

  }

  Future<Tuple3<bool, String, List<Tuple2<String, int>>>> GetChats(int id) async{
    List<Tuple2<String, int>> messages = [];
    int id = globals.userID;
    String out = await backend.sendMessage("", "users/" + id.toString() + "/Chats_List", requestType.GET, Map());
    final answer = jsonDecode(out) as Map<String, dynamic>;
    if(answer["Error-bool"] == true){
      return Tuple3(false, answer["Error-Message"], messages);
    }
    List<String> groups = out.split(",");
    for(var i = 0; i < groups.length; i++){
      messages.add(Tuple2(groups[i].split('.')[0],int.parse(groups[i].split('.')[1])));
    }
    return Tuple3(true, "Laden der Chats Erfolgreich", messages);
  }

}
class GetMessage {
  // use IP 10.0.2.2 to access localhost from windows client 
  static const _backend = "http://127.0.0.1:8080/";
  
  // use IP 10.0.2.2 to access localhost from emulator! 
  // static const _backend = "http://10.0.2.2:8080/";

  // Get messages for a specific group
  Future<List<Message>> fetchGroupMessages(
      http.Client client,int userId, int groupId) async {
    final response = await client.get(
      Uri.parse('${_backend}user/$userId/groups/$groupId/messages'),
    );

    if (response.statusCode == 200) {
      return List<Message>.from(
        json
            .decode(utf8.decode(response.bodyBytes))
            .map((x) => Message.fromJson(x)),
      );
    } else {
      throw Exception('Failed to load group messages');
    }
  }

  // Get messages for a specific user
  Future<List<Message>> fetchUserMessages(
      http.Client client, int userId, int fromId) async {
    final response = await client.get(
      Uri.parse('${_backend}users/$userId/$fromId/messages'),
    );

    if (response.statusCode == 200) {
      return List<Message>.from(
        json
            .decode(utf8.decode(response.bodyBytes))
            .map((x) => Message.fromJson(x)),
      );
    } else {
      throw Exception('Failed to load user messages');
    }
  }

}