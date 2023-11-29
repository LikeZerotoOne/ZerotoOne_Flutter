class User {
  String username;
  String password;
  String name;
  String email;


  User({
    required this.username,
    required this.password,
    required this.name,
    required this.email,

  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'email': email,
    };
  }
}
