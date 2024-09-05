import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/model/Group.dart'; // Import your Group model
import 'package:namer_app/model/User.dart'; // Import your User model
import 'package:namer_app/funktion/groupmanager.dart';

class GroupDetailsScreen extends StatefulWidget {
  final GroupManagerFunktion backend;
  final http.Client client;
  final int groupId;

  const GroupDetailsScreen({
    required this.backend,
    required this.client,
    required this.groupId,
  });

  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  late Group _group;
  late List<User> _users;
  late List<User> _usersNotInGroup;

  @override
  void initState() {
    super.initState();
    _group = Group(id: 0, name: '', userList: []);
    _users = [];
    _usersNotInGroup = [];
    fetchGroupDetails();
  }

  Future<void> fetchGroupDetails() async {
    _group = await widget.backend.fetchGroup(widget.client, widget.groupId);
    _users = await widget.backend.fetchUserList(widget.client, widget.groupId);
    _usersNotInGroup = await widget.backend.fetchUserListNotInGroup(widget.client, widget.groupId);

    setState(() {});
  }

  Widget _buildUserList(List<User> userList, bool isInGroup) {
    if (userList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: userList.map((user) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${user.username} (${user.email})'),
              ElevatedButton(
                onPressed: () async {
                  if (isInGroup) {
                    await widget.backend.deleteUserFromGroup(widget.client, widget.groupId, user.id);
                  } else {
                    await widget.backend.addUserToGroup(widget.client, widget.groupId, user.id);
                  }

                  fetchGroupDetails();
                },
                child: Text(isInGroup ? 'Delete' : 'Add'),
              ),
            ],
          );
        }).toList(),
      );
    } else {
      return Text(isInGroup ? 'No users in this group.' : 'All users are already in the group.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Group ID: ${_group.id}'),
            Text('Group Name: ${_group.name}'),
            SizedBox(height: 16),
            Text('Users in this group:'),
            _buildUserList(_users, true),
            SizedBox(height: 16),
            Text('Users not in this group:'),
            _buildUserList(_usersNotInGroup, false),
          ],
        ),
      ),
    );
  }
}
