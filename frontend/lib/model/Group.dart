import 'package:namer_app/model/User.dart';

class Group {
  int id;
  String name;
  List<User> userList; 

  Group({
    required this.id,
    required this.name,
    required this.userList, 
  });

  // parse Item from JSON-data
  factory Group.fromJson(Map<String, dynamic> json) => Group(
      id: json["id"],
      name: json["name"],
      userList: (json["userList"] as List<dynamic>?)
          ?.map((userData) => User.fromJson(userData))
          .toList() ?? [], // Use the null-aware operator and provide a default empty list
    );
  Object? get localhost => null;



  

  // map item to JSON-data (so far not used in app)
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userList": userList.map((user) => user.toJson()).toList(),
      };
}
