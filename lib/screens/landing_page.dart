import 'dart:convert';

import 'package:cowin_slot_checker/constants/app_routs.dart';
import 'package:cowin_slot_checker/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String stateName = "";
  String stateId = "";
  String districtName = "";
  String districtId = "";
  bool isButtonEnabled = false;
  String assets = "assets/banner.svg";

  navigateToDisttictPage() async {
    var result = await Navigator.of(context)
        .pushNamed(AppRoutsConstants.DISTICT_ROUTE, arguments: stateId);
    var encodedData = json.encode(result);
    var deCodedData = json.decode(encodedData);

    setState(() {
      if (deCodedData["fromWhere"] == "fromDistict") {
        districtName = deCodedData["name"];
        districtId = deCodedData["id"].toString();
      }
    });
  }

  navigateToStatePage() async {
    var result = await Navigator.of(context).pushNamed("/states");
    var encodedData = json.encode(result);
    var deCodedData = json.decode(encodedData);

    setState(() {
      if (deCodedData["fromWhere"] == "fromState") {
        stateName = deCodedData["name"];
        stateId = deCodedData["id"];
      }
      districtName = "";
      districtId = "";
    });
    print(stateName);
  }

  void navigateToSlotsScreen() async {
    setState(() {
      isButtonEnabled = stateName.isNotEmpty && districtName.isNotEmpty;
    });

    await Future.delayed(Duration(seconds: 1));

    isButtonEnabled
        ? Navigator.of(context)
            .pushNamed(AppRoutsConstants.SLOT_ROUTE, arguments: [
            stateName.toString(),
            stateId.toString(),
            districtName.toString(),
            districtId.toString(),
          ])
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  const Text(StringConstants.ERROR_SELECT_STATE_AND_DISTRICT),
              duration: const Duration(seconds: 1),
            ),
          );
    setState(() {
      isButtonEnabled = false;
    });
  }

  Widget buildFomSelection({String key, String value = "", Function function}) {
    return Container(
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xFFFAFAFA),
          border: Border.all(color: Color(0xFFD6D6D6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(key),
            InkWell(
              onTap: () {
                if (key == StringConstants.DISTRICT) {
                  stateName.isNotEmpty
                      ? function()
                      : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                StringConstants.ERROR_SELECT_DISTRICT),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                } else {
                  function();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              children: [
                SvgPicture.asset(assets),
                Text(
                  StringConstants.ENTER_YOUR_LOCATION,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 30.0,
                ),
                buildFomSelection(
                    key: StringConstants.STATE,
                    value: stateName,
                    function: navigateToStatePage),
                SizedBox(
                  height: 10.0,
                ),
                buildFomSelection(
                    key: StringConstants.DISTRICT,
                    value: districtName,
                    function: navigateToDisttictPage),
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () {
                    navigateToSlotsScreen();
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: isButtonEnabled
                        ? 50
                        : MediaQuery.of(context).size.width,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF6C6DC9),
                      borderRadius:
                          BorderRadius.circular(isButtonEnabled ? 50.0 : 50.0),
                    ),
                    child: isButtonEnabled
                        ? Icon(Icons.done, color: Colors.white)
                        : Text(
                            StringConstants.GET_SLOTS,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
