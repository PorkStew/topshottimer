import 'package:flutter/material.dart';
import 'package:topshottimer/Views/PageSelector.dart';
import '../../loading.dart';
import 'package:get/get.dart';
import 'package:topshottimer/global.dart';
import 'package:topshottimer/Themes.dart';
class Success extends StatefulWidget {
  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  //variable declarations
  bool _loading = false;
  final _controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    //get passed argument and set it to variable
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    bool pop = arguments['pop'];

    return _loading
        ? Loading() : Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Align(
              //alignment: Alignment.centerLeft,
              child: Column(
                //left aligns the text
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Success!",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        fontFamily: 'Montserrat-Regular',
                        letterSpacing: 0.2),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Premium Features",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        fontFamily: 'Montserrat-Regular',
                        letterSpacing: 0.2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.check, color: Themes.darkButton2Color, size: 34,),
                    Text('Customisable Timer Tone',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2
                      ),),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.check, color: Themes.darkButton2Color, size: 34,),
                    Text('Changeable Timer Delay',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2
                      ),),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.check, color: Themes.darkButton2Color, size: 34,),
                    Text('Random Delay',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2
                      ),),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.check, color: Themes.darkButton2Color, size: 34,),
                    Text('Save Your Strings',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2
                      ),),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.check, color: Themes.darkButton2Color, size: 34,),
                    Text('View Recorded Strings',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2
                      ),),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.check, color: Themes.darkButton2Color, size: 34,),
                    Text('Ad Free',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2
                      ),),
                  ],
                )
              ],
            ),
            SizedBox(height: 20,),
            Container(
                width: 268,
                height: 90,
                //margin: const EdgeInsets.all(15.0),
                //padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Themes.darkButton1Color, width: 3),
                  borderRadius: BorderRadius.circular(10),

                ),
                child:
                Column(children: [
                  Container(
                    width: 268,
                    height: 20,
                    padding: EdgeInsets.only(left: 10, top: 3),
                    child: Text('MONTHLY',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2,
                          color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        color: Themes.darkButton1Color
                    ),
                  ),
                  SizedBox(height: 5,),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Text('1.99 / Month',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                              fontFamily: 'Montserrat-Regular',
                              letterSpacing: 0.2
                          ),),
                        Text('1.99 billed annually as recurring payment',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              fontFamily: 'Montserrat-Regular',
                              letterSpacing: 0.2,
                              color: Colors.grey
                          ), textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                ],)
            ),
            SizedBox(height: 20,),
            SizedBox(
                width: 268,
                height: 60,
                child: Obx(() => ElevatedButton(
                  onPressed: _controller.btnState.value
                      ? () => popView(pop) //process when button is clicked here!
                      : null,
                  child: Text(
                    'SUCCESS',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        fontFamily: 'Montserrat-Regular',
                        letterSpacing: 0.2,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Themes.darkButton2Color,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10))),
                ))),
          ],
        ),
      ),
    );
  }
  //When Success button is clicked depending on where the user came from. go to page selector or pop view
  popView(bool pop) {
    if(pop == true) {
      Get.back();
      Get.back();
    } else if(pop == false) {
      Get.off(() => pageSelector());
    }
  }}

