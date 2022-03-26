// ignore_for_file: file_names

import 'package:flutter/material.dart';

class LoginModel {
  @required
  final String email;
  @required
  final String password;

  const LoginModel({
    required this.email,
    required this.password,
  });
}
