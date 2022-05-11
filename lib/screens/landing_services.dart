import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ritco_app/screens/comments_screenL.dart';
import 'package:ritco_app/screens/profile_screen.dart';
import 'package:ritco_app/services/data_manupilation.dart';
// import 'package:streams_provider/streams_provider.dart';

// class Services extends StatelessWidget {
//   const Services({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamsProvider.value(
//       value: RitcoAPI().services,
//       child: Container(

//       ),
//     );
//   }
// }

class ServicesProvider extends StatefulWidget {
  const ServicesProvider({Key? key}) : super(key: key);

  @override
  State<ServicesProvider> createState() => _ServicesProviderState();
}

class _ServicesProviderState extends State<ServicesProvider> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    // void _selectedPage(int index) {
    //   setState(() {
    //     selectedIndex = index;
    //   });
    //   print(selectedIndex);
    // }

    final List<Widget> _page = [
      buildHomeServices(context),
      CommentScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      // appBar: App,
      backgroundColor: Color.fromRGBO(169, 195, 74, 1),
      body: _page[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: ((value) {
          setState(() {
            selectedIndex = value;
          });
          print(selectedIndex);
        }),
        currentIndex: selectedIndex,
        fixedColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feeds'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
    );
  }
}

Widget buildHomeServices(context) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(169, 195, 74, 1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          // height: 180,
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi there!",
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Text(
                        "How are you doing today?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromARGB(255, 24, 68, 156),
                        ),
                      ),
                    ],
                  ),
                  // const Icon(Icons.star_outline),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Select a services where you would like to take a servey from",
                  style:
                      TextStyle(fontSize: 16, height: 1.5, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All services",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      //iniput survey count;
                      // Text("surveys")
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                    ),
                    child: Container(
                      // height: 300,
                      child: StreamBuilder<QuerySnapshot>(
                          // initialData: 'Initial data',
                          stream: RitcoAPI().services,
                          builder: ((context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            var val = [];
                            if (snapshot.hasError) {}
                            if (snapshot.hasData) {
                              val = snapshot.data!.docs;

                              return ListView.builder(
                                  primary: true,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: val.length,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      ServiceItemWidget(
                                          val[index]['name'].toString(),
                                          val[index]['description'].toString(),
                                          val[index].id,
                                          //make sure there is an id
                                          ''));
                            }

                            return const Center(
                                child: CircularProgressIndicator());
                          })),
                    ),
                    // child: Column(
                    //   children: const [
                    //     SurveyItemWidget(),
                    //     SurveyItemWidget(),
                    //     SurveyItemWidget(),
                    //   ],
                    // ),
                  ),
                )
              ],
            ),
            width: double.infinity,
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.70),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 233, 233, 233),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
          ),
        ),
      ],
    ),
  );
}

//Service Item widget
class ServiceItemWidget extends StatelessWidget {
  String serviceName;
  String description;
  String serviceId;
  String uid;

  ServiceItemWidget(
    this.serviceName,
    this.description,
    this.serviceId,
    this.uid,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //navigate to a list of surveys
        Navigator.of(context)
            .pushNamed("/home-screen", arguments: {"serviceId": serviceId});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      height: 40,
                      width: 40,
                      child: Image.asset(
                        "assets/illustrations/employee.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceName.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            // const Icon(Icons.stairs_outlined),
                            Container(
                                width: MediaQuery.of(context).size.width * .55,
                                // margin: const EdgeInsets.only(left: 8),
                                child: Text(
                                  description,
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey),
                                ))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "Take survey",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
