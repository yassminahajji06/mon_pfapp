class UserModel {
  final int id;
  final String nom;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.nom,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      role: json['role'],
    );
  }
}
