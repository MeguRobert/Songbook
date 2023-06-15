class UserData {
  String email;
  bool isAdmin;
  bool isEditor;

  UserData({
    required this.email,
    required this.isAdmin,
    required this.isEditor,
  });

  @override
  String toString() {
    return 'User{email: $email, isAdmin: $isAdmin, isEditor: $isEditor}';
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'isAdmin': isAdmin,
        'isEditor': isEditor,
      };

  factory UserData.fromJson(dynamic json) => UserData(
        email: json['email'],
        isAdmin: json['isAdmin'],
        isEditor: json['isEditor'],
      );
}
