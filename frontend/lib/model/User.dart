class User {
  String username;
  String password;
  int id;
  String email;
  bool enabled;
  int role;
  String combinedUsername;

  User({
    required this.username,
    required this.password,
    required this.id,
    required this.email,
    required this.enabled,
    required this.role,
    required this.combinedUsername,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '', // Corrected property name
      password: json['password'] ?? '', // Corrected property name
      id: json['id'] ?? 0,
      email: json['email'] ?? '', // Corrected property name
      enabled: json['enabled'] ?? false,
      role: json['role'] ?? 0,
      combinedUsername: json['combinedUsername'] ?? '', // Corrected property name
    );
  }

  // map item to JSON-data (so far not used in app)
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username, // Corrected property name
        "password": password, // Corrected property name
        "email": email, // Corrected property name
        "enabled": enabled,
        "role": role,
        "combinedUsername": combinedUsername, // Corrected property name
  };
}

