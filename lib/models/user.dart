class User {
  final String name;
  final String email;
  final String password;
  final String? photoPath;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.photoPath,
    
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        photoPath: json['photoPath'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'photoPath': photoPath
      };
}
