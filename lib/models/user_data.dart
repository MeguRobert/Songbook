class UserData {
  String id;
  String email;
  bool isAdmin;

  UserData({
    required this.id,
    required this.email,
    required this.isAdmin,
  });

  @override
  String toString() {
    return 'User{email: $email, isAdmin: $isAdmin}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'isAdmin': isAdmin,
      };

  factory UserData.fromJson(dynamic json) => UserData(
        id: json['id'],
        email: json['email'],
        isAdmin: json['isAdmin'],
      );
}
