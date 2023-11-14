class User {
  String username;
  String password;
  String name;
  String email;
  String sex;
  String age;

  User({
    required this.username,
    required this.password,
    required this.name,
    required this.email,
    required this.sex,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'email': email,
      'sex': sex,
      'age': age,
    };
  }
}
