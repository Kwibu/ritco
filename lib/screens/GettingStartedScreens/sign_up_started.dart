import 'package:flutter/material.dart';
import 'package:ritco_app/models/user_informations.dart';

class SignUpStarted extends StatefulWidget {
  const SignUpStarted({Key? key}) : super(key: key);

  @override
  _SignUpStartedState createState() => _SignUpStartedState();
}

class _SignUpStartedState extends State<SignUpStarted> {
  bool isLoading = false;
  String dropdownValue = "Your Sex";
  final _form = GlobalKey<FormState>();

  // ignore: prefer_typing_uninitialized_variables
  var currentDate;
  var _userInformation =
      const UserInformations(firstName: "", lastName: "", age: "", gender: "");

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        _userInformation = UserInformations(
            firstName: _userInformation.firstName,
            lastName: _userInformation.lastName,
            age: currentDate,
            gender: _userInformation.gender);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void addToSignUpObjectHandler() {
      var validateForm = _form.currentState!.validate();
      _form.currentState!.save();

      if (validateForm && currentDate != null && dropdownValue != "Your Sex") {
        Navigator.of(context).pushNamed("/sign-up-credetials", arguments: {
          "firstName": _userInformation.firstName,
          "lastName": _userInformation.lastName,
          "gender": dropdownValue,
          "age": currentDate
        });
      }
    }

    void _goAndLoginHandler() {
      Navigator.of(context).pushNamed("/login");
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                child: Container(
                  width: double.infinity,
                  child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Your Informations",
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                                "Fill out information about you to create your account"),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      labelText: 'Enter your first name',
                                      labelStyle: const TextStyle(fontSize: 12),
                                      suffixIcon: const Icon(Icons.account_box),
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 20)),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Fill your first name";
                                    }

                                    return null;
                                  },
                                  onSaved: (value) {
                                    _userInformation = UserInformations(
                                      firstName: value.toString(),
                                      lastName: _userInformation.lastName,
                                      gender: _userInformation.gender,
                                      age: _userInformation.age,
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          labelText: 'Enter last name',
                                          suffixIcon:
                                              const Icon(Icons.account_box),
                                          labelStyle:
                                              const TextStyle(fontSize: 12),
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  // vertical: 4,
                                                  horizontal: 20)),
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Fill the last name';
                                        }

                                        return null;
                                      },
                                      onSaved: (value) {
                                        _userInformation = UserInformations(
                                          firstName: _userInformation.firstName,
                                          lastName: value.toString(),
                                          age: _userInformation.age,
                                          gender: _userInformation.gender,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0, left: 0, right: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 12),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    color: Colors.white12,
                                                    border: Border.all(
                                                        color: Colors.black38)),
                                                child: DropdownButton<String>(
                                                  value: dropdownValue,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  style: const TextStyle(
                                                      color: Colors.black87),
                                                  isExpanded: true,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      dropdownValue = newValue!;
                                                      _userInformation =
                                                          UserInformations(
                                                              firstName:
                                                                  _userInformation
                                                                      .firstName,
                                                              lastName:
                                                                  _userInformation
                                                                      .lastName,
                                                              age:
                                                                  _userInformation
                                                                      .age,
                                                              gender: newValue);
                                                    });
                                                  },
                                                  underline: Container(
                                                    height: 1,
                                                  ),
                                                  items: <String>[
                                                    "Your Sex",
                                                    "Male",
                                                    'Female',
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          _selectDate(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black45,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              top: 12,
                                              bottom: 12,
                                              right: 10),
                                          // color: Theme.of(context).primaryColor,
                                          child: Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.0),
                                                child: Icon(
                                                  Icons.date_range,
                                                  // color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                currentDate == null
                                                    ? "Your birthday"
                                                    : currentDate
                                                        .toString()
                                                        .substring(0, 10),
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      child: ElevatedButton(
                        onPressed: addToSignUpObjectHandler,
                        child: isLoading == false
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 18),
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontSize: 16),
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
                                borderRadius: BorderRadius.circular(50)),
                            primary: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _goAndLoginHandler,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
