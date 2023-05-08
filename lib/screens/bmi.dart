import 'package:flutter/material.dart';
import '/screens/home.dart';
import '/screens/signup.dart';
import '../constants.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';
import '../widgets/custom_formfield.dart';
import '../widgets/custom_header.dart';
import 'bmi_Cal.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({Key? key}) : super(key: key);

  @override
  _BmiScreen createState() => _BmiScreen();
}

class _BmiScreen extends State<BmiScreen> {
  final ageCtr = TextEditingController();
  final heightCtr = TextEditingController();
  final weightCtr = TextEditingController();

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
                              builder: (context) => bmiCal(
                                  int.parse(ageCtr.text), double.parse(weightCtr.text), double.parse(heightCtr.text))));
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
                    height: 20,
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
                    height: 20,
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
                    height: 20,
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
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
