class UserModel {
  final int id;
  final String email;
  final String first_Name;
  final String last_Name;
  final String avatar;
UserModel({
  required this.id,
  required this.email,
  required this.first_Name,
  required this.last_Name,
  required this.avatar,
});

factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] ?? 0,
    email: json['email'] ?? '',
    first_Name: json['firstName'] ?? 'No Name',
    last_Name: json['lastName'] ?? 'No Name',
    avatar: json['image'] ?? 'https://robohash.org/${json['id']}',
  );
 }
 UserModel copyWith({
  int? id,
  String? email,
  String? first_Name,
  String? last_Name,
  String? avatar,
}) {
  return UserModel(
    id: id ?? this.id,
    email: email ?? this.email,
    first_Name: first_Name ?? this.first_Name,
    last_Name: last_Name ?? this.last_Name,
    avatar: avatar ?? this.avatar,
  );
 }
}