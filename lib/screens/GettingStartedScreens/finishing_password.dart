// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:flutter/material.dart';

// import 'package:ritco_app/services/data_manupilation.dart'
import 'package:ritco_app/models/user_informations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../services/data_manupilation.dart';

class FinishingSignUp extends StatefulWidget {
  const FinishingSignUp({Key? key}) : super(key: key);

  @override
  _FinishingSignUpState createState() => _FinishingSignUpState();
}

class _FinishingSignUpState extends State<FinishingSignUp> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    var _loginDetails = const LoginModel(email: "", password: "");
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final firstName = routeArgs['firstName'];
    final lastName = routeArgs['lastName'];
    final gender = routeArgs['gender'];
    final age = routeArgs['age'];

    // ignore: non_constant_identifier_names
    Future<void> signUpHandler() async {
      var validateForm = _form.currentState!.validate();
      _form.currentState!.save();

      if (validateForm) {
        try {
          setState(() {
            isLoading = true;
          });
          if (validateForm) {
            setState(() {
              isLoading = true;
            });
            var response = await http.post(
                Uri.parse(
                    'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBaEmrUzXNMNPv7khL5ybs18_XE1PhfsW8'),
                body: json.encode({
                  "email": _loginDetails.email.toString(),
                  "password": _loginDetails.password.toString(),
                  "returnSecureToken": true,
                  "firstName": firstName,
                  "lastName": lastName,
                  "fullName": "${firstName} ${lastName}",
                  "displayName": "${firstName} ${lastName}",
                }));

            var userData = json.decode(response.body);
            if (userData['error'] != null) {
              setState(() {
                isLoading = false;
              });

              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: const Text("Oooops"),
                        content: Text(userData['error']['message']),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text("OK"))
                        ],
                      ));
            } else {
              SharedPreferences pref = await SharedPreferences.getInstance();
              await pref.setString("username", "${firstName} ${lastName}");
              await pref.setString("firstname", firstName);
              await pref.setString("lastname", lastName);
              await pref.setString("useraccount", _loginDetails.email);
              await pref.setString('uid', userData['localId']);
              

              RitcoAPI().setDoc('users', userData['localId'], {
                'uid': userData['localId'],
                'email': _loginDetails.email,
                'firstname': firstName,
                'lastname': lastName,
                'gender': gender,
                'age': age
              });
              await Navigator.of(context)
                  .pushReplacementNamed('/landing-services');
              setState(() {
                isLoading = false;
              });
            }
          }
        } catch (error) {
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
        }
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
              ),
              const Padding(
                padding: EdgeInsets.only(top: 50.0, left: 20),
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 60, bottom: 20),
                  width: 180,
                  height: 100,
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "RITCO",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                                BorderRadius.circular(5)),
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
                                                BorderRadius.circular(5)),
                                        labelText: 'Password',
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
                                      signUpHandler();
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
                                  onPressed: signUpHandler,
                                  child: isLoading == false
                                      ? const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14),
                                          child: Text(
                                            "Sign Up",
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
                                              BorderRadius.circular(5)),
                                      primary: Theme.of(context).primaryColor),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                  InkWell(
                    onTap: () => {
                      Navigator.of(context).pushNamed('/sign-up'),
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 50, right: 50, top: 0, bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Create Account",
                              style: TextStyle(
                                  color: Color.fromRGBO(40, 103, 226, 1),
                                  fontSize: 12)),
                          Text("Forgot Password",
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
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
