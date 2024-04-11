import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:radioapp/pages/home.dart';
import 'package:radioapp/pages/otp.dart';
import 'package:radioapp/provider/generalprovider.dart';
import 'package:radioapp/utils/color.dart';
import 'package:radioapp/utils/constant.dart';
import 'package:radioapp/utils/sharedpref.dart';
import 'package:radioapp/utils/utils.dart';
import 'package:radioapp/widget/myimage.dart';
import 'package:radioapp/widget/mytext.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  SharedPref sharedPre = SharedPref();
  final numberController = TextEditingController();
  String mobilenumber = "";
  var email = "";
  String? countryCode;
  int? forceResendingToken;
  String? verificationId;

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Home();
                },
              ),
            );
          },
          child: MyImage(
            width: 15,
            height: 15,
            imagePath: "back.png",
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(25),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.011),
            // Login Page Radio Image Set
            MyImage(imagePath: "radio.png", height: 100, width: 100),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.054,
            ),
            // Welcome Back Text
            const MyText(
                color: black,
                text: "welcomeback",
                multilanguage: true,
                fontsize: 27,
                maxline: 1,
                inter: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.left,
                fontstyle: FontStyle.normal,
                fontwaight: FontWeight.bold),
            SizedBox(height: MediaQuery.of(context).size.height * 0.0050),
            // Enter Mobilenumber Text
            const MyText(
                color: lightgray,
                text: "enteryourmobilenumbertologin",
                multilanguage: true,
                fontsize: 14,
                maxline: 1,
                inter: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.left,
                fontstyle: FontStyle.normal,
                fontwaight: FontWeight.w400),
            SizedBox(height: MediaQuery.of(context).size.height * 0.052),
            // Mobile number TextField
            phonetextfield(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.028),
            // Login Button
            loginbutton(),
            const SizedBox(height: 30),
            // Or Text
            orSection(),
            const SizedBox(height: 17),
            // Google Signin Button (Show Only Android Devices)
            gmaillogin(),
            const SizedBox(height: 17),
            // Apple Signin Button (Show Only IOS and macOS Devices)
            Platform.isIOS || Platform.isMacOS
                ? applelogin()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget phonetextfield() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      child: IntlPhoneField(
        disableLengthCheck: true,
        textAlignVertical: TextAlignVertical.center,
        autovalidateMode: AutovalidateMode.disabled,
        controller: numberController,
        style: Utils.googleFontStyle(
            1, 16, FontStyle.normal, black, FontWeight.w500),
        showCountryFlag: false,
        showDropdownIcon: false,
        initialCountryCode: 'IN',
        dropdownTextStyle: Utils.googleFontStyle(
            1, 16, FontStyle.normal, lightgray, FontWeight.w500),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: false,
          hintStyle: Utils.googleFontStyle(
              1, 14, FontStyle.normal, lightgray, FontWeight.w500),
          hintText: Constant.enteryourmobilenumber,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: lightgray, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: lightgray, width: 2),
          ),
        ),
        onChanged: (phone) {
          log('phone===> ${phone.completeNumber}');
          log('number===> ${numberController.text}');
          mobilenumber = phone.completeNumber;
          log('mobile number===>mobileNumber $mobilenumber');
        },
        onCountryChanged: (country) {
          countryCode = "+${country.dialCode.toString()}";
          log('===> ${country.code}');
        },
      ),
    );
  }

  loginbutton() {
    return InkWell(
      onTap: () {
        if (numberController.text.toString().isEmpty) {
          Utils.showSnackbar(context, "pleaseenteryourmobilenumber", true);
        } else {
          codeSend();
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
            text: "login",
            fontsize: 18,
            maxline: 1,
            multilanguage: true,
            inter: 3,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
            fontwaight: FontWeight.w600),
      ),
    );
  }

  Row orSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 88.0, right: 15.0),
            child: const Divider(
              color: gray,
            ),
          ),
        ),
        const MyText(
            color: lightgray,
            text: "or",
            multilanguage: true,
            fontsize: 14,
            maxline: 1,
            inter: 1,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
            fontwaight: FontWeight.w400),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 88.0),
            child: const Divider(
              color: gray,
            ),
          ),
        ),
      ],
    );
  }

  gmaillogin() {
    return InkWell(
      onTap: () {
        gmailLogin();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.83,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: lightwhite,
        ),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            MyImage(
              height: 23,
              imagePath: "google_logo.png",
              width: 23,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            const MyText(
                color: black,
                text: "loginwithgoogle",
                multilanguage: true,
                fontsize: 14,
                maxline: 1,
                inter: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal,
                fontwaight: FontWeight.w500),
          ],
        ),
      ),
    );
  }

  applelogin() {
    return InkWell(
      onTap: () {
        // Apple Signin Set Using Firebase
        signInWithApple();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.83,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: lightwhite,
        ),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            MyImage(
              height: 23,
              imagePath: "ic_apple.png",
              width: 23,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            const MyText(
                color: black,
                text: "loginwithapple",
                fontsize: 14,
                maxline: 1,
                multilanguage: true,
                inter: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal,
                fontwaight: FontWeight.w500),
          ],
        ),
      ),
    );
  }

  codeSend() async {
    Utils().showProgress(context);
    await phoneSignIn(phoneNumber: mobilenumber);
    if (!mounted) return;
    Utils().hideProgress(context);
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendingToken,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    log("verification completed ======> ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    log("user phoneNumber =====> ${user?.phoneNumber}");
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      log("The phone number entered is invalid!");
      Utils.showSnackbar(context, "thephonenumberenteredisinvalid", true);
      Utils().hideProgress(context);
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    this.forceResendingToken = forceResendingToken;
    log("verificationId =======> $verificationId");
    log("resendingToken =======> ${forceResendingToken.toString()}");
    log("code sent");
    Utils.showSnackbar(context, "coderesendsuccsessfully", true);
    Utils().hideProgress(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OTP(
          vrrificationid: verificationId,
          mobilenumber: mobilenumber,
        ),
      ),
    );
  }

  _onCodeTimeout(String verificationId) {
    log("_onCodeTimeout verificationId =======> $verificationId");
    this.verificationId = verificationId;
    Utils().hideProgress(context);
    return null;
  }

  // Login With Google
  Future<void> gmailLogin() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    GoogleSignInAccount user = googleUser;

    debugPrint('GoogleSignIn ===> id : ${user.id}');
    debugPrint('GoogleSignIn ===> email : ${user.email}');
    debugPrint('GoogleSignIn ===> displayName : ${user.displayName}');
    debugPrint('GoogleSignIn ===> photoUrl : ${user.photoUrl}');

    if (!mounted) return;
    Utils().showProgress(context);

    UserCredential userCredential;
    try {
      GoogleSignInAuthentication googleSignInAuthentication =
          await user.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      userCredential = await auth.signInWithCredential(credential);
      assert(await userCredential.user?.getIdToken() != null);
      debugPrint("User Name: ${userCredential.user?.displayName}");
      debugPrint("User Email ${userCredential.user?.email}");
      debugPrint("User photoUrl ${userCredential.user?.photoURL}");
      debugPrint("uid ===> ${userCredential.user?.uid}");
      String firebasedid = userCredential.user?.uid ?? "";
      debugPrint('firebasedid :===> $firebasedid');
      // Call Login Api
      if (!mounted) return;
      Utils().showProgress(context);
      loginApi("2", "", user.email);
    } on FirebaseAuthException catch (e) {
      debugPrint('===>Exp${e.code.toString()}');
      debugPrint('===>Exp${e.message.toString()}');
      Utils().hideProgress(context);
    }
  }

  /* Apple Login */
  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      debugPrint(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult = await auth.signInWithCredential(oauthCredential);

      final displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      debugPrint("displayName =====> $displayName");

      final firebaseUser = authResult.user;
      debugPrint("=================");

      final userEmail = '${firebaseUser?.email}';
      debugPrint("userEmail =====> $userEmail");
      debugPrint(firebaseUser?.email.toString());
      debugPrint(firebaseUser?.displayName.toString());
      debugPrint(firebaseUser?.photoURL.toString());
      debugPrint(firebaseUser?.uid);
      debugPrint("=================");

      final firebasedId = firebaseUser?.uid;
      debugPrint("firebasedId ===> $firebasedId");

      // await firebaseUser?.updateDisplayName(displayName);
      // await firebaseUser?.updatePhotoURL(photoURL);
      // await firebaseUser?.updateEmail(userEmail);

      /* Save PhotoUrl in File */
      // mProfileImg = await Utils.saveImageInStorage(S

      loginApi("2", "", userEmail);
    } catch (exception) {
      debugPrint("Apple Login exception =====> $exception");
    }
    return null;
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
