import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:echoverse/pages/editprofile.dart';
import 'package:echoverse/provider/profileprovider.dart';
import 'package:echoverse/utils/color.dart';
import 'package:echoverse/utils/constant.dart';
import 'package:echoverse/utils/sharedpref.dart';
import 'package:echoverse/utils/utils.dart';
import 'package:echoverse/widget/myappbar.dart';
import 'package:echoverse/widget/myimage.dart';
import 'package:echoverse/widget/mynetworkimg.dart';
import 'package:echoverse/widget/mytext.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  SharedPref sharedpre = SharedPref();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  String userid = "";

  @override
  void initState() {
    super.initState();
    getApi();
  }

  getApi() async {
    userid = await sharedpre.read("userid");
    if (!mounted) return;
    final profileprovider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileprovider.getProfile(userid);

    usernameController.text =
        profileprovider.profileModel.result?[0].name.toString() ?? "";
    emailController.text =
        profileprovider.profileModel.result?[0].email.toString() ?? "";
    numberController.text =
        profileprovider.profileModel.result?[0].mobile.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // AppBar
            Stack(
              children: [
                MyAppbar(
                  isSimpleappbar: 2,
                  title: "profile",
                  onBack: () {
                    Navigator.of(context).pop(false);
                  },
                  icon: "back,png",
                ),
                // Profile Image
                Consumer<ProfileProvider>(
                    builder: (context, profileprovider, child) {
                  if (profileprovider.loading) {
                    return Utils.pageLoader();
                  } else {
                    return Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: MyNetworkImage(
                              fit: BoxFit.cover,
                              imgWidth: 110,
                              imgHeight: 110,
                              imageUrl: profileprovider
                                      .profileModel.result?[0].image
                                      .toString() ??
                                  ""),
                        ),
                      ),
                    );
                  }
                }),
              ],
            ),
            // Body
            profilebody(),
          ],
        ),
      ),
    );
  }

  Widget profilebody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.060),
          // Enter Username
          profileTextFields(Constant.username, "ic_user.png",
              usernameController, TextInputType.text, TextInputAction.next),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          // Enter Email
          profileTextFields(Constant.email, "ic_email.png", emailController,
              TextInputType.text, TextInputAction.next),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          // Enter MobileNumber
          profileTextFields(Constant.mobile, "ic_mobile.png", numberController,
              TextInputType.number, TextInputAction.done),
          SizedBox(height: MediaQuery.of(context).size.height * 0.20),
          // EditButton
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EditProfile(
                      userid: userid,
                    );
                  },
                ),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.065,
              width: MediaQuery.of(context).size.width * 0.50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [colorAccent, orange],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(50)),
              child: const MyText(
                color: white,
                multilanguage: true,
                text: "edit",
                fontwaight: FontWeight.w600,
                fontsize: 18,
                inter: 1,
                fontstyle: FontStyle.normal,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Username,Email And Number Common TextField
  Widget profileTextFields(String hinttext, String icon, dynamic controller,
      dynamic keyboardtype, dynamic textinputAction) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        keyboardType: keyboardtype,
        textInputAction: textinputAction,
        controller: controller,
        cursorColor: black,
        readOnly: true,
        style: Utils.googleFontStyle(
            1, 16, FontStyle.normal, black, FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: Container(
            width: 15,
            height: 15,
            alignment: Alignment.center,
            child: MyImage(
              width: 20,
              height: 20,
              imagePath: icon,
              color: gray,
            ),
          ),
          filled: true,
          fillColor: lightgray.withOpacity(0.40),
          contentPadding: const EdgeInsets.all(12.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            borderSide:
                BorderSide(width: 1, color: lightgray.withOpacity(0.80)),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            borderSide:
                BorderSide(width: 1, color: lightgray.withOpacity(0.80)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            borderSide:
                BorderSide(width: 1, color: lightgray.withOpacity(0.80)),
          ),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(7)),
              borderSide:
                  BorderSide(width: 1, color: lightgray.withOpacity(0.80))),
          hintText: hinttext,
          hintStyle: Utils.googleFontStyle(
              1, 16, FontStyle.normal, black, FontWeight.w500),
        ),
      ),
    );
  }
}
