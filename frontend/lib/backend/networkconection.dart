//import 'dart:js_interop_unsafe';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:namer_app/backend/globals.dart' as globals;

class Backend {
  // use IP 10.0.2.2 to access localhost from windows client
  static const _backend = "http://localhost:8080/";
  http.Client _client;

  Backend({http.Client? client}) : _client = client ?? http.Client();
  // use IP 10.0.2.2 to access localhost from emulator!
  // static const _backend = "http://10.0.2.2:8080/";

  Future<String> sendMessage(String message, String requestpath, requestType type, Map<String, dynamic> queryParams) async{

    //Message to JSON map
    Map data = {
      'content': message
    };

    Map<String, dynamic> user = {
      'User-ID' : globals.userID
    };

    queryParams.addAll(user);
    queryParams.forEach((key, value) => queryParams[key] = value.toString());


    //Intializing Neccessary Variables
    var response;
    String urifull = _backend + requestpath;
    var _client = http.Client();
    //Switch on Request Type And Doing REST Connction
    switch (type) {
      case requestType.GET:                                               //GET
        response = await _client.get(Uri.parse(urifull).replace(queryParameters: queryParams),
          headers: <String, String>{'Content-Type':'application/json'});
        break;
    case requestType.POST:                                                //POST
        response = await _client.post(Uri.parse(urifull).replace(queryParameters: queryParams),
          headers: <String, String>{'Content-Type':'application/json'},
          body: json.encode(data));
        break;
      case requestType.PUT:                                               //PUT
        response = await _client.put(Uri.parse(urifull).replace(queryParameters: queryParams),
        headers: <String, String>{'Content-Type':'application/json'},
        body: json.encode(data));
        break;
      case requestType.DELETE:                                            //Delete
        response = await _client.delete(Uri.parse(urifull).replace(queryParameters: queryParams),
        headers: <String, String>{'Content-Type':'application/json'},
        body: json.encode(data));
        break;
      case requestType.HEAD:                                              //Head
        response = await _client.head(Uri.parse(urifull).replace(queryParameters: queryParams),
        headers: <String, String>{'Content-Type':'application/json'});
        break;
      case requestType.PATCH:                                             //Patch
        response = await _client.patch(Uri.parse(urifull).replace(queryParameters: queryParams),
        headers: <String, String>{'Content-Type':'application/jsoin'},
        body: json.encode(data));
        break;
      case requestType.READ:                                              //Read
        response = await _client.read(Uri.parse(urifull).replace(queryParameters: queryParams),
        headers: <String, String>{'Content-Type':'application/json'});
        break;

    }

    //Processing Response From Server
    if(response.statusCode == 200){
      return utf8.decode(response.bodyBytes);
    } else{
      Map error = {
        'Error-Code': response.statusCode,
      };
      return json.encode(error);
    }

  }

bool isError(String response){
    try{
      Map<String, dynamic> JSON = json.decode(response);
      if(JSON.containsKey("Error-Code")){
        return true;
      }
    } catch(e){
      return false;
    }
    return false;
  }

  setHttp(http.Client client){
    _client = client;
  }

  
}

  



//Acceptet Message Types
enum requestType{
    GET,
    POST,
    PUT,
    DELETE,
    HEAD,
    PATCH,
    READ
  }
