import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '/constants.dart';

enum SingingCharacter { Male, Female }

class bodyFatCal extends StatefulWidget {
  int age;
  String gender;
  int weight;
  int height;
  int neck;
  int waist;
  int hip;

  bodyFatCal(this.age, this.gender, this.weight, this.height, this.neck, this.waist, this.hip, {Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _bodyFatCal();
}

class _bodyFatCal extends State<bodyFatCal> {
  CategoriesScroller categoriesScroller =
      CategoriesScroller("0", "0", "0", "0", "0");
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  @override
  void initState() {
    super.initState();

    getBodyFatData();
    controller.addListener(() {
      double value = controller.offset / 119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  void getBodyFatData() async {
    var response = await http.get(
        Uri.parse(
            'https://fitness-calculator.p.rapidapi.com/bodyfat?age=${widget.age}&gender=${widget.gender}&weight=${widget.weight}&height=${widget.height}&neck=${widget.neck}&waist=${widget.waist}&hip=${widget.hip}'),
        headers: {"X-RapidAPI-Key": "40ffd96d69mshd80a4da1f877867p174810jsnf6135876a8c1"});
    //check if it is OK
    if (response.statusCode == 200) {
      print('Web service is 200');

      //response in object data type
      var data = jsonDecode(response.body);
      print(data['data']['Body Fat Category']);
      print(data['data']['Body Fat (U.S. Navy Method)']);
      print(data['data']['Body Fat (BMI method)']);
      print(data['data']['Body Fat Mass']);
      print(data['data']['Lean Body Mass']);

      // สั่ง set state ใหม่
      setState(() {
        categoriesScroller = CategoriesScroller(
            data['data']['Body Fat Category'].toString(),
            data['data']['Body Fat (U.S. Navy Method)'].toString(),
            data['data']['Body Fat (BMI method)'].toString(),
            data['data']['Body Fat Mass'].toString(),
            data['data']['Lean Body Mass'].toString());
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: const BoxDecoration(
              color: kBlueLightColor,
              image: DecorationImage(
                image: AssetImage("assets/images/meditation_bg.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          categoriesScroller
        ],
      ),
    );
  }
}

class CategoriesScroller extends StatelessWidget {
  final String category, bodyFatUS, bodyFatBmi, bodyFatMass, leanBodyMas;
  CategoriesScroller(this.category, this.bodyFatUS, this.bodyFatBmi, this.bodyFatMass, this.leanBodyMas);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.05,
              ),
              Text(
                "Body Fat Percentage",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 20),
              Text(
                "Result",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: size.width * .6,
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 20),
                      height: 125,
                      decoration:
                          BoxDecoration(color: kBlueColor, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "สัดส่วนของไขมันในร่างกายของคุณอยู่ในระดับ",
                              style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            category == 'null'
                                ? Text('ไม่สามารถระบุได้', style: TextStyle(fontSize: 20, color: kBlueLightColor))
                                : Text(category, style: TextStyle(fontSize: 20, color: kBlueLightColor)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Body Fat",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 17),
                      blurRadius: 23,
                      spreadRadius: -13,
                      color: kShadowColor,
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Body Fat (U.S. Navy Method)",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("ไขมันในร่างกาย $bodyFatUS %")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.fitness_center,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 17),
                      blurRadius: 23,
                      spreadRadius: -13,
                      color: kShadowColor,
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Body Fat (BMI method)",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("ไขมันในร่างกาย $bodyFatBmi %")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.directions_run,
                        size: 40,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 17),
                      blurRadius: 23,
                      spreadRadius: -13,
                      color: kShadowColor,
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Body Fat Mass",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("มวลไขมันในร่างกาย $bodyFatMass kgs")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.food_bank,
                        size: 40,
                        color: Colors.lightGreen,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 17),
                      blurRadius: 23,
                      spreadRadius: -13,
                      color: kShadowColor,
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Lean Body Mass",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("มวลกายแบบลีน $leanBodyMas kgs")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.fastfood,
                        size: 40,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
