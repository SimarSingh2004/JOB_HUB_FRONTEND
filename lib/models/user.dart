class UserModel {
  final String id;
  final String fullname;
  final String email;
  final String username;
  final String role;
  final String avatar;

  const UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.username,
    required this.role,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? '',
      fullname: json['fullname']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullname': fullname,
      'email': email,
      'username': username,
      'role': role,
      'avatar': avatar,
    };
  }

  // Add a copyWith method for easy updates
  UserModel copyWith({
    String? id,
    String? fullname,
    String? email,
    String? username,
    String? role,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      username: username ?? this.username,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
    );
  }

  // Override equality and hashCode for better comparison and debugging
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullname == other.fullname &&
          email == other.email &&
          role == other.role &&
          username == other.username &&
          avatar == other.avatar;

  @override
  int get hashCode =>
      id.hashCode ^
      fullname.hashCode ^
      email.hashCode ^
      role.hashCode ^
      username.hashCode ^
      avatar.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, role: $role)';
  }
}
