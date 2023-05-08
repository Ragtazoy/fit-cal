import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '/constants.dart';

enum SingingCharacter { Male, Female }

class dailyCalorieCal extends StatefulWidget {
  int age;
  String gender;
  int height;
  int weight;
  String activity;
  dailyCalorieCal(this.age, this.gender, this.height, this.weight, this.activity, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _dailyCalorieCal();
}

class _dailyCalorieCal extends State<dailyCalorieCal> {
  CategoriesScroller categoriesScroller = CategoriesScroller("Loading...", "Loading...", "Loading...", "Loading...",
      "Loading...", "Loading...", "Loading...", "Loading...", "Loading...");
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  @override
  void initState() {
    super.initState();
    print(widget.age);
    print(widget.gender);
    print(widget.height);
    print(widget.weight);
    print(widget.activity);

    getDailyCalData();
    controller.addListener(() {
      double value = controller.offset / 119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  void getDailyCalData() async {
    var response = await http.get(
        Uri.parse(
            'https://fitness-calculator.p.rapidapi.com/dailycalorie?age=${widget.age}&gender=${widget.gender}&height=${widget.height}&weight=${widget.weight}&activitylevel=${widget.activity}'),
        headers: {"X-RapidAPI-Key": "40ffd96d69mshd80a4da1f877867p174810jsnf6135876a8c1"});
    //check if it is OK
    if (response.statusCode == 200) {
      print('Web service is 200');

      //response in object data type
      var data = jsonDecode(response.body);
      print(data['data']['BMR']);
      print(data['data']['goals']['Extreme weight loss']['loss weight']);
      print(data['data']['goals']['Extreme weight loss']['calory']);
      print(data['data']['goals']['Weight loss']['loss weight']);
      print(data['data']['goals']['Weight loss']['calory']);
      print(data['data']['goals']['Weight loss']['loss weight']);
      print(data['data']['goals']['Weight gain']['calory']);
      print(data['data']['goals']['Extreme weight gain']['gain weight']);
      print(data['data']['goals']['Extreme weight gain']['calory']);

      // สั่ง set state ใหม่
      setState(() {
        categoriesScroller = CategoriesScroller(
            data['data']['BMR'].toString(),
            data['data']['goals']['Extreme weight loss']['loss weight'].toString(),
            data['data']['goals']['Extreme weight loss']['calory'].toString(),
            data['data']['goals']['Weight loss']['loss weight'].toString(),
            data['data']['goals']['Weight loss']['calory'].toString(),
            data['data']['goals']['Weight gain']['gain weight'].toString(),
            data['data']['goals']['Weight gain']['calory'].toString(),
            data['data']['goals']['Extreme weight gain']['gain weight'].toString(),
            data['data']['goals']['Extreme weight gain']['calory'].toString());
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
            decoration: BoxDecoration(
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
  final String bmr, xwlLossWeight, xwlCalory, wlLossWeight, wlCalory, wgGainWeight, wgCalory, xwgGainWeight, xwgCalory;
  CategoriesScroller(this.bmr, this.xwlLossWeight, this.xwlCalory, this.wlLossWeight, this.wlCalory, this.wgGainWeight,
      this.wgCalory, this.xwgGainWeight, this.xwgCalory);

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
                "Daily Calorie Requirements",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 20),
              Text(
                "Result",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              SizedBox(
                width: size.width * .6,
                child: Container(
                  width: 150,
                  margin: EdgeInsets.only(right: 20),
                  height: 125,
                  decoration: BoxDecoration(color: kBlueColor, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "BMR พลังงานที่จำเป็นพื้นฐานในการใช้ชีวิต",
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          bmr + '  kcal',
                          style: TextStyle(fontSize: 20, color: kBlueLightColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Goals",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                height: 120,
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
                            "Goal 1 ลดน้ำหนักแบบขั้นสุด",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("น้ำหนักที่ลดได้ $xwlLossWeight"),
                          Text("พลังงานที่ต้องการ $xwlCalory kcal")
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
                height: 120,
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
                            "Goal 2 ลดน้ำหนักแบบปกติ",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("น้ำหนักที่ลดได้ $wlLossWeight"),
                          Text("พลังงานที่ต้องการ $wlCalory kcal")
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
                height: 120,
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
                            "Goal 3 เพิ่มน้ำหนักแบบปกติ",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("น้ำหนักที่เพิ่มได้ $wgGainWeight"),
                          Text("พลังงานที่ต้องการ $wgCalory kcal")
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
                height: 120,
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
                            "Goal 4 เพิ่มน้ำหนักแบบขั้นสุด",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("น้ำหนักที่เพิ่มได้ $xwgGainWeight"),
                          Text("พลังงานที่ต้องการ $xwgCalory kcal")
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
