import 'dart:convert';

import 'package:flutter/material.dart';
import '../../models/loginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    var _loginDetails = const LoginModel(email: "", password: "");
    // ignore: non_constant_identifier_names
    Future<void> loginButton_handler() async {
      var validateForm = _form.currentState!.validate();
      _form.currentState!.save();

      void gotToDashboard(user, dashboardRoute) async {
        if (user["data"]['access_token'] != null) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString("token", user["data"]['access_token']);
          final username = await pref.setString(
              'username', user["data"]["user_details"]["user_name"]);

          if (username) {
            await Navigator.of(context)
                .pushReplacementNamed(dashboardRoute, arguments: {
              "username": user['data']["user_details"]["user_name"],
              "role": user['data']["user_details"]["role"],
              "token": user["data"]['access_token']
            });
          }
        }
      }

      if (validateForm) {
        setState(() {
          isLoading = true;
        });
        await http
            .post(
                Uri.parse(
                    'https://identitytoolkit.googleapis.com/v1/accounts:signIn?key=AIzaSyBaEmrUzXNMNPv7khL5ybs18_XE1PhfsW8'),
                body: ({
                  "email": _loginDetails.email,
                  "password": _loginDetails.password
                }))
            .then((response) async {
          var user = jsonDecode(response.body);
          if (user['data']['user_details']['role'] == 'company') {
            gotToDashboard(user, '/landlord_dashboard');
          }
          if (user['data']['user_details']['role'] == 'tenant') {
            gotToDashboard(user, '/tenant_dashboard');
          }

          setState(() {
            isLoading = false;
          });
        }).catchError((onError) {
          print(onError);
          setState(() {
            isLoading = false;
          });
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text("Oooops"),
                    content: const Text(
                        "Invalid Credentials or check your internet connection"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("OK"))
                    ],
                  ));
        });
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // Text(
                    //   "Login",
                    //   style: TextStyle(fontSize: 20, fontFamily: "Poppins"),
                    // ),
                    // Text(
                    //     "Before the journey begin you can wait for confirmation email"),
                  ],
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 60, bottom: 20),
                  width: 180,
                  height: 200,
                  child: const Text(
                    "LITCO LTD",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        labelText: 'Enter your email',
                                        labelStyle:
                                            const TextStyle(fontSize: 12),
                                        suffixIcon: const Icon(Icons.email),
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 20)),
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Fill your email";
                                      }
                                      if (value.isNotEmpty &&
                                          (!value.contains("@") ||
                                              !value.contains("."))) {
                                        return "email is invalid";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _loginDetails = LoginModel(
                                          email: value.toString(),
                                          password: _loginDetails.password);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        labelText: 'Enter your password',
                                        suffixIcon: const Icon(Icons.lock),
                                        labelStyle:
                                            const TextStyle(fontSize: 12),
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                // vertical: 4,
                                                horizontal: 20)),
                                    textInputAction: TextInputAction.done,
                                    obscureText: true,
                                    onFieldSubmitted: (_) {
                                      loginButton_handler();
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Fill the password';
                                      }
                                      if (value.length < 6) {
                                        return "Week password";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _loginDetails = LoginModel(
                                          email: _loginDetails.email,
                                          password: value.toString());
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: ElevatedButton(
                                  onPressed: loginButton_handler,
                                  child: isLoading == false
                                      ? const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14),
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Poppins'),
                                          ),
                                        )
                                      : const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      primary: const Color.fromRGBO(
                                          104, 153, 17, 1)),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 50, right: 50, top: 0, bottom: 50),
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: const [
                    //     Text("Create Account",
                    //         style:
                    //             TextStyle(color: Colors.green, fontSize: 12)),
                    //     Text("Forgot Password", style: TextStyle(fontSize: 12)),
                    //   ],
                    // ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
