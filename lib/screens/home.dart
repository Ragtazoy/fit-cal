import '/screens/bmi.dart';
import '/screens/body_fat.dart';
import '/screens/ideal_weight.dart';
import '/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'daily_calorie.dart';
import '/widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userFullname = "Loading...";

  @override
  void initState() {
    super.initState();
    print("init login state");
    checkAuth(context);
    getUserData();
  }

  Future checkAuth(BuildContext context) async {
    print('check auth');
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Signin()));
      } else {
        print('User is signed in!');
      }
    });
  }

  void getUserData() {
    print("Welcome to getUserData");
    var userId = auth.currentUser!.uid;
    print("Current user id: ${userId}");
    FirebaseFirestore.instance.collection("users").doc(userId).get().then((value) {
      var fullname = value["profile"]["fname"] + " " + value["profile"]["lname"];
      setState(() {
        userFullname = fullname;
      });
      print('userFullname:' + userFullname);
    }).catchError((e) {
      print(e.toString());
      setState(() {
        userFullname = "Jeerayuth Suwanprasert";
      });
    });
  }

  Future signOut(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    print("logout...");
    Navigator.of(context)
        .pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => new Signin()), (route) => false);
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; //device screen size
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            // Here the height of the container is 45% of our total height
            height: size.height * .45,
            decoration: BoxDecoration(
              color: Color(0xFFF5CEB8),
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: Color(0xFFF2BEA1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                          icon: Icon(Icons.logout, color: Colors.white),
                          onPressed: () {
                            print("before logout");
                            signOut(context);
                          }),
                    ),
                  ),
                  Text("Hello", style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),),
                  Text(
                    userFullname,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 30),
                  Text("แอปสำหรับคนรักการออกกำลังกาย!!", style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 30),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        CategoryCard(
                          title: "BMI Calculate",
                          svgSrc: "assets/icons/Hamburger.svg",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return BmiScreen();
                              }),
                            );
                          },
                        ),
                        CategoryCard(
                          title: "Body Fat Calculate",
                          svgSrc: "assets/icons/Excrecises.svg",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return BodyFatScreen();
                              }),
                            );
                          },
                        ),
                        CategoryCard(
                          title: "Daily Calorie Requirements",
                          svgSrc: "assets/icons/Meditation.svg",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return DailyCalorieScreen();
                              }),
                            );
                          },
                        ),
                        CategoryCard(
                          title: "Ideal Weight",
                          svgSrc: "assets/icons/yoga.svg",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return IdealWeightScreen();
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
