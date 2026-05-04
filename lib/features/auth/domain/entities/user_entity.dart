class UserEntity {
  final String id;
  final String email;
  final bool isDeleted;

  const UserEntity({
    required this.id,
    required this.email,
    this.isDeleted = false,
  });
}
