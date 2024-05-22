class UserSearchDTO {
  final String email;


  const UserSearchDTO({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "Email": email,
    };
  }
}
