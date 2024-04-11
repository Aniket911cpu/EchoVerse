import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:echoverse/pages/home.dart';
import 'package:echoverse/provider/generalprovider.dart';
import 'package:echoverse/utils/color.dart';
import 'package:echoverse/utils/sharedpref.dart';
import 'package:echoverse/utils/utils.dart';
import 'package:echoverse/widget/myimage.dart';
import 'package:echoverse/widget/mytext.dart';

class OTP extends StatefulWidget {
  final String vrrificationid;
  final String mobilenumber;
  const OTP({
    super.key,
    required this.mobilenumber,
    required this.vrrificationid,
  });

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  SharedPref sharedPre = SharedPref();
  final pinPutController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: white,
        elevation: 0,
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop(false);
          },
          child: MyImage(
            width: 15,
            height: 15,
            imagePath: "back.png",
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              const MyText(
                  color: black,
                  text: "verifyphonenumber",
                  multilanguage: true,
                  fontsize: 26,
                  maxline: 1,
                  inter: 3,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                  fontwaight: FontWeight.w600),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              const MyText(
                  color: lightgray,
                  text: "wehavesentcodetoyournumber",
                  fontsize: 16,
                  multilanguage: true,
                  maxline: 1,
                  inter: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                  fontwaight: FontWeight.w400),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              MyText(
                  color: lightgray,
                  text: widget.mobilenumber,
                  fontsize: 16,
                  maxline: 1,
                  inter: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                  fontwaight: FontWeight.w400),
              SizedBox(height: MediaQuery.of(context).size.height * 0.039),
              Pinput(
                length: 6,
                keyboardType: TextInputType.number,
                controller: pinPutController,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                defaultPinTheme: PinTheme(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: red, width: 1),
                    shape: BoxShape.rectangle,
                    color: lightwhite,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  textStyle: Utils.googleFontStyle(
                      1, 16, FontStyle.normal, black, FontWeight.w500),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.040),
              InkWell(
                onTap: () {
                  if (pinPutController.text.isEmpty) {
                    Utils.showSnackbar(context, "pleaseemteryourotp", true);
                  } else {
                    Utils().showProgress(context);
                    checkOTPAndLogin();
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.83,
                  height: MediaQuery.of(context).size.height * 0.07,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [colorAccent, orange],
                      end: Alignment.topRight,
                      begin: Alignment.topLeft,
                    ),
                  ),
                  child: const MyText(
                      color: white,
                      text: "confirm",
                      fontsize: 18,
                      multilanguage: true,
                      maxline: 1,
                      inter: 3,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                      fontwaight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.031,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const MyText(
                        color: black,
                        text: "resend",
                        fontsize: 14,
                        multilanguage: true,
                        maxline: 1,
                        inter: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                        fontwaight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkOTPAndLogin() async {
    bool error = false;
    UserCredential? userCredential;

    log("_checkOTPAndLogin verificationId =====> ${widget.vrrificationid}");
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential? phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: widget.vrrificationid,
      smsCode: pinPutController.text.toString(),
    );

    log("phoneAuthCredential.smsCode   =====> ${phoneAuthCredential.smsCode}");
    log("phoneAuthCredential.verificationId =====> ${phoneAuthCredential.verificationId}");
    try {
      userCredential = await auth.signInWithCredential(phoneAuthCredential);
      log("_checkOTPAndLogin userCredential =====> ${userCredential.user?.phoneNumber ?? ""}");
    } on FirebaseAuthException catch (e) {
      Utils().hideProgress(context);
      log("_checkOTPAndLogin error Code =====> ${e.code}");
      if (e.code == 'invalid-verification-code' ||
          e.code == 'invalid-verification-id') {
        if (!mounted) return;
        Utils.showSnackbar(context, "entervalidotp", true);
        return;
      } else if (e.code == 'session-expired') {
        if (!mounted) return;
        Utils.showSnackbar(context, "otpsessionexpired", true);
        return;
      } else {
        error = true;
      }
    }
    log("Firebase Verification Complated & phoneNumber => ${userCredential?.user?.phoneNumber} and isError => $error");
    if (!error && userCredential != null) {
      // Call Login Api
      loginApi("1", widget.mobilenumber.toString(), "");
    } else {
      if (!mounted) return;
      Utils().hideProgress(context);
      Utils.showSnackbar(context, "loginfail", true);
    }
  }

  loginApi(String type, String mobile, String email) async {
    final loginItem = Provider.of<GeneralProvider>(context, listen: false);

    await loginItem.getLogin(type, mobile, email);

    if (!loginItem.loading) {
      if (loginItem.loginModel.status == 200 &&
          loginItem.loginModel.result!.isNotEmpty) {
        await sharedPre.save(
            "userid", loginItem.loginModel.result?[0].id.toString());
        await sharedPre.save(
            "fullname", loginItem.loginModel.result?[0].name.toString());
        await sharedPre.save(
            "username", loginItem.loginModel.result?[0].mobile.toString());
        await sharedPre.save(
            "email", loginItem.loginModel.result?[0].email.toString());
        await sharedPre.save("mobilenumber",
            loginItem.loginModel.result?[0].password.toString());
        await sharedPre.save(
            "image", loginItem.loginModel.result?[0].image.toString());
        await sharedPre.save(
            "type", loginItem.loginModel.result?[0].type.toString());
        await sharedPre.save("devicetoken",
            loginItem.loginModel.result?[0].coinBalance.toString());
        await sharedPre.save(
            "status", loginItem.loginModel.result?[0].status.toString());
        await sharedPre.save(
            "createat", loginItem.loginModel.result?[0].createdAt.toString());
        await sharedPre.save(
            "updateat", loginItem.loginModel.result?[0].updatedAt.toString());
        if (!mounted) return;
        Utils().hideProgress(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Home()),
            (Route route) => false);
      } else {
        if (!mounted) return;
        Utils().hideProgress(context);
      }
    }
  }
}
