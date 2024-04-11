class Constant {
  final String baseurl = " ";

  static String? appName = "DTRadio";
  static String? appPackageName = "com.divinetechs.dtradio";
  static String? appleAppId = "";

  String razorpaykey = "";
  static String currencySymbol = "";

  /* OneSignal App ID */
  static const String oneSignalAppId = "";

  // HintText TextField
  static String search = "Search";
  static String username = "Username";
  static String email = "Email";
  static String mobile = "Mobile";
  static String password = "Password";
  static String enteryourmobilenumber = "Enter Your Mobile Number";

  // Toast Message All App
  // static String pleaseentermobilenumber = "Please Enter Your Mobile Number";
  static String tendigitnumber = "Mobile Number must be of 10 digit";
  static String pleasewait = "Please Wait";

  static String androidAppShareUrlDesc =
      "Let me recommend you this application\n\n$androidAppUrl";
  static String iosAppShareUrlDesc =
      "Let me recommend you this application\n\n$iosAppUrl";

  static String androidAppUrl =
      "https://play.google.com/store/apps/details?id=${Constant.appPackageName}";
  static String iosAppUrl =
      "https://apps.apple.com/us/app/id${Constant.appleAppId}";
  static String facebookUrl = "https://www.facebook.com/divinetechs/";
  static String instagramUrl = "https://www.instagram.com/divinetechs/";
}
