import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:echoverse/utils/color.dart';
import 'package:echoverse/utils/constant.dart';
import 'package:echoverse/widget/myimage.dart';
import 'package:echoverse/widget/mytext.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  ProgressDialog? prDialog;

  // FontFamily All app Text
  static TextStyle googleFontStyle(int inter, double fontsize,
      FontStyle fontstyle, Color color, FontWeight fontwaight) {
    if (inter == 1) {
      return GoogleFonts.poppins(
          fontSize: fontsize,
          fontStyle: fontstyle,
          color: color,
          fontWeight: fontwaight);
    } else if (inter == 2) {
      return GoogleFonts.lobster(
          fontSize: fontsize,
          fontStyle: fontstyle,
          color: color,
          fontWeight: fontwaight);
    } else if (inter == 3) {
      return GoogleFonts.rubik(
          fontSize: fontsize,
          fontStyle: fontstyle,
          color: color,
          fontWeight: fontwaight);
    } else {
      return GoogleFonts.inter(
          fontSize: fontsize,
          fontStyle: fontstyle,
          color: color,
          fontWeight: fontwaight);
    }
  }

  Widget noData(BuildContext context, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.30),
        MyImage(
          height: 80,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.contain,
          color: lightgray,
          imagePath: "ic_mic.png",
        ),
        const SizedBox(height: 7),
        MyText(
            color: lightgray,
            text: text.toString(),
            multilanguage: true,
            textalign: TextAlign.center,
            fontsize: 18,
            inter: 1,
            maxline: 1,
            fontwaight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
            fontstyle: FontStyle.normal),
      ],
    );
  }

  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: red,
        textColor: white,
        fontSize: 14);
  }

  static Widget myAppbar(
      BuildContext context, String title, String icon, onBack) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.14,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorAccent,
            orange,
          ],
          end: Alignment.bottomLeft,
          begin: Alignment.topRight,
        ),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // Category AppBar With BackButton
          AppBar(
            backgroundColor: transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 10,
            leading: InkWell(
              onTap: onBack,
              child: MyImage(width: 15, height: 15, imagePath: icon),
            ),
            title: MyText(
                color: white,
                text: title,
                textalign: TextAlign.center,
                fontsize: 22,
                inter: 1,
                maxline: 2,
                fontwaight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
                fontstyle: FontStyle.normal),
            centerTitle: true,
          ),
        ],
      ),
    );
  }

  static Widget pageLoader() {
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: red,
      ),
    );
  }

  static void showSnackbar(
      BuildContext context, String message, bool multilanguage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: red,
        content: MyText(
          text: message,
          fontsize: 14,
          multilanguage: multilanguage,
          fontstyle: FontStyle.normal,
          fontwaight: FontWeight.w500,
          color: white,
          textalign: TextAlign.center,
        ),
      ),
    );
  }

  // Global Progress Dilog
  void showProgress(BuildContext context) async {
    prDialog = ProgressDialog(context);
    prDialog = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false, showLogs: false);

    prDialog!.style(
      message: Constant.pleasewait,
      borderRadius: 5,
      progressWidget: Container(
        padding: const EdgeInsets.all(8),
        child: const CircularProgressIndicator(),
      ),
      maxProgress: 100,
      progressTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: white,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: const TextStyle(
        color: black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    );

    await prDialog!.show();
  }

  void hideProgress(BuildContext context) async {
    prDialog = ProgressDialog(context);
    if (prDialog!.isShowing()) {
      prDialog!.hide();
    }
  }

// KMB Text Generator Method
  static String kmbGenerator(int num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  static Future<void> redirectToUrl(String url) async {
    debugPrint("_launchUrl url ===> $url");
    if (await canLaunchUrl(Uri.parse(url.toString()))) {
      await launchUrl(
        Uri.parse(url.toString()),
        mode: LaunchMode.platformDefault,
      );
    } else {
      throw "Could not launch $url";
    }
  }

  static Future<void> redirectToStore() async {
    final appId =
        Platform.isAndroid ? Constant.appPackageName : Constant.appleAppId;
    final url = Uri.parse(
      Platform.isAndroid
          ? "market://details?id=$appId"
          : "https://apps.apple.com/app/id$appId",
    );
    debugPrint("_launchUrl url ===> $url");
    if (await canLaunchUrl(Uri.parse(url.toString()))) {
      await launchUrl(
        Uri.parse(url.toString()),
        mode: LaunchMode.platformDefault,
      );
    } else {
      throw "Could not launch $url";
    }
  }

  static Future<void> shareApp(shareMessage) async {
    try {
      await FlutterShare.share(
        title: Constant.appName ?? "",
        linkUrl: shareMessage,
      );
    } catch (e) {
      debugPrint("shareFile Exception ===> $e");
      return;
    }
  }
}
