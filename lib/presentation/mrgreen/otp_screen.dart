import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:wilotv/infrastructure/core/pref_manager.dart';
import 'package:wilotv/presentation/mrgreen/suggestions.dart';
import '../../domain/entities/user.dart';
import 'package:flutter/services.dart';
import 'package:wilotv/presentation/utils/constants.dart';
import 'package:wilotv/presentation/utils/app_themes.dart';

import '../components/custom_button.dart';
import '../components/waiting_dialog.dart';

import '../../infrastructure/api/api_service.dart';

import '../components/toast.dart';

import 'package:http/http.dart';

class OTPScreen extends StatefulWidget {
  final User user;
  OTPScreen(this.user);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var otp = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final _pageController = PageController();

  Duration time = Duration(minutes: 2);

  bool t = true;

  startTimer() {
    t = true;
    loopTimer();
  }

  loopTimer() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      time = Duration(seconds: time.inSeconds - 1);
    });

    if(time.inSeconds == 0) t = false;

    if(t) loopTimer();
  }

  resetTimer() async {
    time = Duration(minutes: 2);
    startTimer();
  }

  stopTimer() async {
    t = false;
  }


  @override
  void initState() {
    startTimer();
    super.initState();
  }

  String error = '';

  @override
  Widget build(BuildContext context) {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: kColorPrimary.withOpacity(0.25),
      borderRadius: BorderRadius.circular(8.0),
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        titleSpacing: 0.0,
        shadowColor: Color(0xffedeeee),
        title: Text(
          'Verification',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Poppins',),

                  children: [
                    TextSpan(text: 'OTP Sent to '),
                    TextSpan(text: widget.user.email, style: TextStyle(color: kColorPrimary, fontWeight: FontWeight.bold )),
                  ]
              ),
            ),
            SizedBox(height: 16,),
            PinPut(

              validator: (s) {
                if (s.contains('1')) return null;
                return 'NOT VALID';
              },
              //useNativeKeyboard: false,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              withCursor: true,
              fieldsCount: 4,
              fieldsAlignment: MainAxisAlignment.spaceAround,
              textStyle: const TextStyle(fontSize: 25.0, color: kColorPrimary),
              eachFieldMargin: EdgeInsets.all(0),
              eachFieldWidth: 45.0,
              eachFieldHeight: 55.0,
              inputDecoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  counterText: ''
              ),
              //onSubmit: (String pin) => _showSnackBar(pin),
              focusNode: _pinPutFocusNode,
              controller: otp,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration.copyWith(
                color: Colors.white.withOpacity(0.25),
                border: Border.all(
                  width: 2,
                  color: kColorPrimary,
                ),
              ),
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.scale,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
            SizedBox(height: 16,),

            if(error.isNotEmpty) Text(error, style: TextStyle( color: Colors.red,fontWeight: FontWeight.bold, fontSize: 14 ,  fontFamily: 'Poppins')),

            Row(
              children: [
                Text(_printDuration(time)),
                SizedBox(width: 8,),
                CupertinoButton(
                  child: Text('Resend OTP', style: TextStyle( color: time.inSeconds == 0 ? kColorPrimary : Colors.grey ,fontWeight: FontWeight.bold, fontSize: 14 ,  fontFamily: 'Poppins')),
                  onPressed: time.inSeconds == 0 ? () async {
                    showWaitingDialog(context);

                    final e = await HeyPApiService.create().resendOTP(widget.user.email);

                    resetTimer();

                    showToast(e.body.message);

                    Navigator.of(context).pop();

                  }: null,
                  pressedOpacity: 0.5,
                  padding: EdgeInsets.all(0.0),
                ),
              ],
            ),

            CustomButton(
              title: 'Verify',
              onPressed: () async {
                showWaitingDialog(context);

                final e = await HeyPApiService.create().verifyOTP(otp.text, widget.user.email);

                showToast(e.body.message);
                if(e.body.success){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } else {

                }
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
