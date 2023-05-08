import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '/constants.dart';

class bmiCal extends StatefulWidget {
  int age;
  double weight;
  double height;
  bmiCal(this.age, this.weight, this.height, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _bmiCal();
}

class _bmiCal extends State<bmiCal> {
  CategoriesScroller categoriesScroller = CategoriesScroller('0', '0');
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  @override
  void initState() {
    super.initState();
    print(widget.age);
    print(widget.weight);
    print(widget.height);

    getBmiData();
    controller.addListener(() {
      double value = controller.offset / 119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  void getBmiData() async {
    var response = await http.get(
        Uri.parse(
            'https://fitness-calculator.p.rapidapi.com/bmi?age=${widget.age}&weight=${widget.weight}&height=${widget.height}'),
        headers: {"X-RapidAPI-Key": "40ffd96d69mshd80a4da1f877867p174810jsnf6135876a8c1"});
    //check if it is OK
    if (response.statusCode == 200) {
      print('Web service is 200');

      //response in object data type
      var data = jsonDecode(response.body);
      print(data['data']['bmi']);
      print(data['data']['health']);

      // สั่ง set state ใหม่
      setState(() {
        categoriesScroller = CategoriesScroller(data['data']['bmi'].toString(), data['data']['health'].toString());
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
  final String bmi, health;
  CategoriesScroller(this.bmi, this.health);

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
                "Body Mass\nIndex Value",
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
                          "BMI ค่าดัชนีมวลกายของคุณคือ",
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          bmi,
                          style: TextStyle(fontSize: 20, color: kBlueLightColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Health",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: const [
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
                            "$health",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (double.parse(bmi) < 18.5) ...[
                            const Text("น้ำหนักน้อย / ผอม"),
                          ] else if (double.parse(bmi) < 22.9) ...[
                            const Text("ปกติ (สุขภาพดี)"),
                          ] else if (double.parse(bmi) < 24.9) ...[
                            const Text("ท้วม / เริ่มอ้วน"),
                          ] else if (double.parse(bmi) < 29.9) ...[
                            const Text("อ้วน / โรคอ้วนระดับ 2"),
                          ] else ...[
                            const Text("อ้วนมาก / โรคอ้วนระดับ 3"),
                          ],
                          Text("ค่า BMI ที่ดีควรอยู่ระหว่าง 18.5 - 25")
                        ],
                      ),
                    ),
                    if (double.parse(bmi) < 18.5) ...[
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.fastfood,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ] else if (double.parse(bmi) < 22.9) ...[
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.sentiment_very_satisfied,
                          size: 40,
                          color: Colors.green,
                        ),
                      ),
                    ] else if (double.parse(bmi) < 24.9) ...[
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.sentiment_satisfied_alt_rounded,
                          size: 40,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ] else if (double.parse(bmi) < 29.9) ...[
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.directions_run,
                          size: 40,
                          color: Colors.amber,
                        ),
                      ),
                    ] else ...[
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.fitness_center,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ],
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
