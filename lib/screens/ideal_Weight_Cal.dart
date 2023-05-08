import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/constants.dart';

enum SingingCharacter { Male, Female }

class idealWeightCal extends StatefulWidget {
  String gender;
  int height;

  idealWeightCal(this.gender, this.height, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _idealWeightCal();
}

class _idealWeightCal extends State<idealWeightCal> {
  CategoriesScroller categoriesScroller = CategoriesScroller("Loading...", "Loading...", "Loading...", "Loading...");
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
            'https://fitness-calculator.p.rapidapi.com/idealweight?gender=${widget.gender}&height=${widget.height}'),
        headers: {"X-RapidAPI-Key": "40ffd96d69mshd80a4da1f877867p174810jsnf6135876a8c1"});
    //check if it is OK
    if (response.statusCode == 200) {
      print('Web service is 200');

      //response in object data type
      var data = jsonDecode(response.body);
      print(data['data']['Hamwi']);
      print(data['data']['Devine']);
      print(data['data']['Miller']);
      print(data['data']['Robinson']);

      // สั่ง set state ใหม่
      setState(() {
        categoriesScroller = CategoriesScroller(data['data']['Hamwi'].toString(), data['data']['Devine'].toString(),
            data['data']['Miller'].toString(), data['data']['Robinson'].toString());
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
  final String hamwi, devine, miller, robinson;
  CategoriesScroller(this.hamwi, this.devine, this.miller, this.robinson);

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
                "Ideal Body Weight",
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
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "น้ำหนักในอุดมคติที่ได้จาก 4 รูปแบบสมการ มีดังนี้",
                              style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Fomulars",
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
                            "Robinson Formula",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("น้ำหนักในอุดมคติ คือ $robinson kgs")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.monitor_weight,
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
                            "Miller Formula",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("น้ำหนักในอุดมคติ คือ $miller kgs")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.monitor_weight,
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
                            "Devine Formula",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("น้ำหนักในอุดมคติ คือ $devine kgs")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.monitor_weight,
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
                            "Hamwi Formula",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("น้ำหนักในอุดมคติ คือ $hamwi kgs")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.monitor_weight,
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
