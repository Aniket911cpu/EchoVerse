import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:echoverse/pages/home.dart';
import 'package:echoverse/provider/profileprovider.dart';
import 'package:echoverse/provider/updateprofileprovider.dart';
import 'package:echoverse/utils/color.dart';
import 'package:echoverse/utils/constant.dart';
import 'package:echoverse/utils/utils.dart';
import 'package:echoverse/widget/myappbar.dart';
import 'package:echoverse/widget/myimage.dart';
import 'package:echoverse/widget/mynetworkimg.dart';
import 'package:echoverse/widget/mytext.dart';

class EditProfile extends StatefulWidget {
  final String userid;
  const EditProfile({super.key, required this.userid});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker picker = ImagePicker();
  XFile? _image;
  bool iseditimg = false;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getApi();
  }

  getApi() async {
    final profileprovider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileprovider.getProfile(widget.userid);

    usernameController.text =
        profileprovider.profileModel.result?[0].name.toString() ?? "";
    emailController.text =
        profileprovider.profileModel.result?[0].email.toString() ?? "";
    numberController.text =
        profileprovider.profileModel.result?[0].mobile.toString() ?? "";
    passwordController.text =
        profileprovider.profileModel.result?[0].password.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              children: [
                // AppBar
                MyAppbar(
                  isSimpleappbar: 2,
                  title: "editprofile",
                  onBack: () {
                    Navigator.of(context).pop(false);
                  },
                  icon: "back,png",
                ),
                // UserProfile And Change Image Icon
                Consumer<ProfileProvider>(
                    builder: (context, profileProvider, child) {
                  return Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _image == null
                                ? MyNetworkImage(
                                    fit: BoxFit.cover,
                                    imgWidth: 110,
                                    imgHeight: 110,
                                    imageUrl: profileProvider
                                            .profileModel.result?[0].image
                                            .toString() ??
                                        "")
                                : Image.file(
                                    File(_image!.path),
                                    fit: BoxFit.cover,
                                    width: 110,
                                    height: 110,
                                  ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () async {
                                  // Select Image From Gallary and Camera
                                  var image = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 100);
                                  setState(() {
                                    _image = image;
                                    iseditimg = true;
                                  });
                                },
                                child: Card(
                                  color: white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  elevation: 1,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: white, shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child:
                                        const Icon(Icons.camera_alt_outlined),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
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
              TextInputType.number, TextInputAction.next),

          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          profileTextFields(Constant.password, "ic_password.png",
              passwordController, TextInputType.number, TextInputAction.done),
          SizedBox(height: MediaQuery.of(context).size.height * 0.20),
          // EditButton
          InkWell(
            onTap: () async {
              File image;
              //  Call Update Profile Api Using Provider
              String name = usernameController.text.toString();
              String email = emailController.text.toString();
              String mobile = numberController.text.toString();
              String password = passwordController.text.toString();

              if (iseditimg) {
                image = File(_image?.path ?? "");
              } else {
                image = File("");
              }

              final updateprofileProvider =
                  Provider.of<UpdateProfileProvider>(context, listen: false);
              Utils().showProgress(context);
              await updateprofileProvider.getUpdateProfile(
                  widget.userid, name, email, mobile, password, image);

              if (!updateprofileProvider.loading) {
                if (updateprofileProvider.updateprofileModel.status == 200) {
                  if (!mounted) return;
                  Utils().hideProgress(context);
                  Utils().showToast(updateprofileProvider
                      .updateprofileModel.message
                      .toString());
                  getApi();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Home();
                      },
                    ),
                  );
                } else {
                  if (!mounted) return;
                  Utils().hideProgress(context);
                  Utils().showToast(updateprofileProvider
                      .updateprofileModel.message
                      .toString());
                }
              }
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
                text: "save",
                fontwaight: FontWeight.w600,
                fontsize: 18,
                multilanguage: true,
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
        style: Utils.googleFontStyle(
            1, 16, FontStyle.normal, black, FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: Container(
            width: 15,
            height: 15,
            alignment: Alignment.center,
            child: MyImage(
              width: 23,
              height: 23,
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
