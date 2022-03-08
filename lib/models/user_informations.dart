class UserInformations {
  final String firstName;
  final String lastName;
  final String age;
  final String gender;

  const UserInformations(
      {required this.firstName,
      required this.lastName,
      required this.age,
      required this.gender});
}

class LoginModel {
  final String email;
  final String password;

  const LoginModel({
    required this.email,
    required this.password,
  });
}
