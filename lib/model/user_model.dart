class User {
  late int id;
  late String email;
  late String firstName;
  late String lastName;
  late List<dynamic> addresses;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.addresses,
  });
}
