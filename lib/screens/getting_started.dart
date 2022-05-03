import 'package:flutter/material.dart';

class GettingStartedScreen extends StatelessWidget {
  const GettingStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          padding:
              const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width * .60,
                      child: Image.asset(
                        "assets/illustrations/ritco_ill.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: const Text(
                      "Help us to improve our services",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .01,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        child: const Text(
                          "We use surveys to find out attitudes and reactions to measure client satisfaction, this helps us to add credibility to our serveices",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/getting-started-signup');
                },
                //navigate to signup screen
                child: Container(
                  // padding: const EdgeInsets.only(bottom: 30),
                  width: double.infinity,

                  decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
