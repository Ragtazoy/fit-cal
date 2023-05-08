import 'package:flutter/material.dart';
import '/screens/home.dart';
import '/screens/signup.dart';
import '../constants.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';
import '../widgets/custom_formfield.dart';
import '../widgets/custom_header.dart';
import 'daily_Calorie_Cal.dart';

class DailyCalorieScreen extends StatefulWidget {
  const DailyCalorieScreen({Key? key}) : super(key: key);

  @override
  _DailyCalorieScreen createState() => _DailyCalorieScreen();
}

enum Gender { Male, Female }

class _DailyCalorieScreen extends State<DailyCalorieScreen> {
  final ageCtr = TextEditingController();
  Gender gender = Gender.Male;
  String actualGender = 'male';
  final TextEditingController genderCtr = new TextEditingController();
  final heightCtr = TextEditingController();
  final weightCtr = TextEditingController();
  String activityLevel = 'level_1: กินพออยู่';

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
                              builder: (context) =>
                                  dailyCalorieCal(int.parse(ageCtr.text), actualGender, int.parse(heightCtr.text), int.parse(weightCtr.text), activityLevel.substring(0,7))));
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.09),
                    child: Text("กรุณากรอกข้อมูล",
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 40)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFormField(
                    headingText: "Age",
                    hintText: "Age",
                    obsecureText: false,
                    suffixIcon: const Icon(Icons.person),
                    controller: ageCtr,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 16,
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
                    hintText: "Height",
                    obsecureText: false,
                    suffixIcon: const Icon(Icons.height),
                    controller: heightCtr,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                    headingText: "Weight",
                    hintText: "Weight",
                    obsecureText: false,
                    suffixIcon: const Icon(Icons.monitor_weight),
                    controller: weightCtr,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.number,
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
                      "Activity Level",
                      style: KTextStyle.textFieldHeading,
                    ),
                  ),
                  Container(
                      color: Color.fromARGB(255, 249, 249, 249),
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                      ),
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: activityLevel,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black, fontSize: 16),
                        underline: Container(
                          height: 2,
                          color: kActiveIconColor,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            activityLevel = newValue!;
                          });
                        },
                        items: <String>[
                          'level_1: กินพออยู่',
                          'level_2: ออกกำลังกายเล็กน้อยหรือไม่ออกเลย',
                          'level_3: ออกกำลังกาย 1-3 ครั้ง/สัปดาห์',
                          'level_4: ออกกำลังกาย 4-5 ครั้ง/สัปดาห์',
                          'level_5: ออกกำลังกายทุกวันหรือออกกำลังกายหนักๆ 3-4 ครั้ง/สัปดาห์',
                          'level_6: ออกกำลังกายแบบเข้มข้น 6-7 ครั้ง/สัปดาห์',
                          'level_7: ออกกำลังกายหนักมากทุกวันหรืองานทางกายภาพ'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
