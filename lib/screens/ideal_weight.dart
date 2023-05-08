import '/screens/home.dart';
import '/screens/signup.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';
import '../widgets/custom_formfield.dart';
import '../widgets/custom_header.dart';
import 'ideal_Weight_Cal.dart';

class IdealWeightScreen extends StatefulWidget {
  const IdealWeightScreen({Key? key}) : super(key: key);

  @override
  _IdealWeightScreen createState() => _IdealWeightScreen();
}

enum Gender { Male, Female }

class _IdealWeightScreen extends State<IdealWeightScreen> {
  Gender gender = Gender.Male;
  String actualGender = 'male';
  final TextEditingController genderCtr = new TextEditingController();
  final heightCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: kActiveIconColor,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CustomHeader(
              text: 'Back',
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Calculate",
                    style: KTextStyle.headerTextStyle,
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => idealWeightCal(
                                    actualGender,
                                    int.parse(heightCtr.text),
                                  )));
                    },
                    child: const Icon(
                      Icons.calculate_sharp,
                      color: AppColors.whiteshade,
                      size: 24,
                    ),
                  ),
                ],
              ),
            )
          ]),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: AppColors.whiteshade,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.09),
                    child: Text("กรุณากรอกข้อมูล   ",
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 40)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
                    child: Text(
                      "Gender",
                      style: KTextStyle.textFieldHeading,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('Male'),
                        leading: Radio<Gender>(
                          value: Gender.Male,
                          groupValue: gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              gender = value!;
                              actualGender = 'male';
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Female'),
                        leading: Radio<Gender>(
                          value: Gender.Female,
                          groupValue: gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              gender = value!;
                              actualGender = 'female';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                    headingText: "Height",
                    hintText: "Height (cm)",
                    obsecureText: false,
                    suffixIcon: const Icon(Icons.height),
                    controller: heightCtr,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
