import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:echoverse/pages/allradioviewall.dart';
import 'package:echoverse/pages/artistviewall.dart';
import 'package:echoverse/pages/categoryviewall.dart';
import 'package:echoverse/pages/cityviewall.dart';
import 'package:echoverse/pages/favorite.dart';
import 'package:echoverse/pages/getradiobyartist.dart';
import 'package:echoverse/pages/getradiobycategory.dart';
import 'package:echoverse/pages/getradiobycity.dart';
import 'package:echoverse/pages/getradiobylanguage.dart';
import 'package:echoverse/pages/languageviewall.dart';
import 'package:echoverse/pages/latestradioviewall.dart';
import 'package:echoverse/pages/login.dart';
import 'package:echoverse/pages/commonpage.dart';
import 'package:echoverse/pages/musicdetails.dart';
import 'package:echoverse/pages/notification.dart';
import 'package:echoverse/pages/profile.dart';
import 'package:echoverse/pages/search.dart';
import 'package:echoverse/provider/homeprovider.dart';
import 'package:echoverse/provider/profileprovider.dart';
import 'package:echoverse/utils/color.dart';
import 'package:echoverse/utils/constant.dart';
import 'package:echoverse/utils/customwidget.dart';
import 'package:echoverse/utils/musicmanager.dart';
import 'package:echoverse/utils/sharedpref.dart';
import 'package:echoverse/utils/utils.dart';
import 'package:echoverse/widget/myimage.dart';
import 'package:echoverse/widget/mynetworkimg.dart';
import 'package:echoverse/widget/mytext.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

ValueNotifier<AudioPlayer?> currentlyPlaying = ValueNotifier(null);
const double playerMinHeight = 100;
const miniplayerPercentageDeclaration = 0.6;
late ConcatenatingAudioSource playlist;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPref sharedpre = SharedPref();
  String userid = "";
  String aboutus = "";
  String termscondition = "";
  String privacypolicy = "";
  var scrollController = ScrollController();
  final MusicManager _musicManager = MusicManager();
  final GlobalKey<ScaffoldState> drawerkey = GlobalKey<ScaffoldState>();
  double ratingValue = 0.0;
  PageController pagecontroller =
      PageController(initialPage: 0, viewportFraction: 0.9);
  late ConcatenatingAudioSource playlist;

  @override
  initState() {
    super.initState();
    getApi();
    if (!kIsWeb) {
      OneSignal.shared.setNotificationOpenedHandler(_handleNotificationOpened);
    }
  }

  getApi() async {
    final homeprovider = Provider.of<HomeProvider>(context, listen: false);
    await homeprovider.getBanner();
    await homeprovider.getCategory("1");
    await homeprovider.getLanguage("1");
    await homeprovider.getAllSong("1");
    await homeprovider.getCity(1);
    await homeprovider.getLatestSong("1");
    await homeprovider.getArtist("1");

    userid = await sharedpre.read("userid") ?? "";
    debugPrint("userid => $userid");
    await homeprovider.valueUpdate(userid);
    if (userid.isNotEmpty && userid != "") {
      await homeprovider.getFavourite(userid, "1");
      if (!mounted) return;
      final profileprovider =
          Provider.of<ProfileProvider>(context, listen: false);
      await profileprovider.getProfile(userid);
    }

    aboutus = await sharedpre.read("about-us") ?? "";
    privacypolicy = await sharedpre.read("privacy-policy") ?? "";
    termscondition = await sharedpre.read("terms-and-conditions") ?? "";
  }

  // What to do when the user opens/taps on a notification
  _handleNotificationOpened(OSNotificationOpenedResult result) {
    /* id, image, name, song_url */

    log("setNotificationOpenedHandler additionalData ===> ${result.notification.additionalData.toString()}");
    log("setNotificationOpenedHandler id ===> ${result.notification.additionalData?['id']}");
    log("setNotificationOpenedHandler image ===> ${result.notification.additionalData?['image']}");
    log("setNotificationOpenedHandler name ===> ${result.notification.additionalData?['name']}");
    log("setNotificationOpenedHandler song_url ===> ${result.notification.additionalData?['song_url']}");

    if (result.notification.additionalData?['id'] != null &&
        result.notification.additionalData?['song_url'] != null) {
      String? songID =
          result.notification.additionalData?['id'].toString() ?? "";
      String? songImage =
          result.notification.additionalData?['image'].toString() ?? "";
      String? songName =
          result.notification.additionalData?['name'].toString() ?? "";
      String? songUrl =
          result.notification.additionalData?['song_url'].toString() ?? "";
      log("songID    =====> $songID");
      log("songImage =====> $songImage");
      log("songName  =====> $songName");
      log("songUrl   =====> $songUrl");
      _musicManager.playSingleSong(songID, songName, songUrl, songImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exitDilog(context),
      child: Stack(
        children: [
          Scaffold(
            key: drawerkey,
            backgroundColor: lightwhite,
            drawerEnableOpenDragGesture: true,
            // appBar: PreferredSize(
            //   preferredSize:
            //       Size.fromHeight(MediaQuery.of(context).size.height * 0.2),
            //   child: homeappbar(),
            // ),
            drawer: homeDrawer(),
            body: homebody(),
          ),
          _buildMusicPanel(context),
        ],
      ),
    );
  }

// Home Drawer
  Widget homeDrawer() {
    debugPrint("userid=>$userid");
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Drawer(
        backgroundColor: white,
        elevation: 0,
        width: MediaQuery.of(context).size.width * 0.80,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            drawerItem("ic_language.png", "changelanguage", () {
              if (drawerkey.currentState!.isDrawerOpen) {
                drawerkey.currentState!.openEndDrawer();
              } else {
                drawerkey.currentState!.openDrawer();
              }
              changeLanguage(context);
            }),
            divider(),
            drawerItem("ic_tc.png", "termsconditions", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CommonPage(
                      title: "termsconditions",
                      url: termscondition.toString(),
                    );
                  },
                ),
              );
            }),
            divider(),
            drawerItem("ic_about.png", "aboutus", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CommonPage(
                      title: "aboutus",
                      url: aboutus.toString(),
                    );
                  },
                ),
              );
            }),
            divider(),
            drawerItem("ic_privacy.png", "privacypolicy", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CommonPage(
                      title: "privacypolicy",
                      url: privacypolicy.toString(),
                    );
                  },
                ),
              );
            }),
            divider(),
            drawerItem("ic_share.png", "shareapp", () async {
              // Button Click and Generate Application Link
              // And After Share Button Click
              await Utils.shareApp(Platform.isIOS
                  ? Constant.iosAppShareUrlDesc
                  : Constant.androidAppShareUrlDesc);
            }),
            divider(),
            drawerItem("ic_rateapp.png", "rateapp", () {
              if (drawerkey.currentState!.isDrawerOpen) {
                drawerkey.currentState!.openEndDrawer();
              } else {
                drawerkey.currentState!.openDrawer();
              }
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog(
                      elevation: 5,
                      insetPadding: const EdgeInsets.all(30),
                      insetAnimationCurve: Curves.easeInExpo,
                      insetAnimationDuration: const Duration(seconds: 1),
                      backgroundColor: Colors.transparent,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.35,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RatingBar(
                              initialRating: 0.0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemSize: 45,
                              glowColor: orange,
                              unratedColor: gray,
                              glow: false,
                              itemCount: 5,
                              ratingWidget: RatingWidget(
                                full: const Icon(
                                  Icons.star,
                                  color: orange,
                                ),
                                half:
                                    const Icon(Icons.star_half, color: orange),
                                empty: const Icon(Icons.star_border,
                                    color: lightgray),
                              ),
                              onRatingUpdate: (double value) {
                                debugPrint("rating=> $value");
                                ratingValue = value;
                              },
                            ),
                            const MyText(
                                color: black,
                                text: "enjoyingmyradio",
                                textalign: TextAlign.center,
                                fontsize: 18,
                                maxline: 1,
                                multilanguage: true,
                                inter: 1,
                                fontwaight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal),
                            const MyText(
                                color: lightgray,
                                text: "tapastartorateitontheappstore",
                                textalign: TextAlign.center,
                                multilanguage: true,
                                fontsize: 14,
                                inter: 1,
                                maxline: 2,
                                fontwaight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (ratingValue == 0.0) {
                                      Utils().showToast(
                                          "Please Enter Your Rating");
                                    } else {
                                      // App Rating Api Call After Button Click
                                      debugPrint("Clicked on rateApp");
                                      await Utils.redirectToStore();
                                    }
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          colors: [colorAccent, orange],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const MyText(
                                        color: white,
                                        text: "submit",
                                        textalign: TextAlign.center,
                                        fontsize: 16,
                                        inter: 1,
                                        multilanguage: true,
                                        maxline: 2,
                                        fontwaight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                        fontstyle: FontStyle.normal),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: gray, width: 1),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const MyText(
                                        color: gray,
                                        text: "cancel",
                                        textalign: TextAlign.center,
                                        fontsize: 16,
                                        multilanguage: true,
                                        inter: 1,
                                        maxline: 2,
                                        fontwaight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                        fontstyle: FontStyle.normal),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }),
            const Spacer(),
            InkWell(
              onTap: () {
                debugPrint("userid=>$userid");
                if (userid.isEmpty || userid == "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Login();
                      },
                    ),
                  );
                } else {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      builder: (context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.25,
                          color: white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const MyText(
                                  color: black,
                                  text: "areyousurewanttologout",
                                  multilanguage: true,
                                  textalign: TextAlign.center,
                                  fontsize: 18,
                                  inter: 1,
                                  maxline: 6,
                                  fontwaight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      removeUseridFromLocal();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const Login();
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 100,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            colorPrimary,
                                            colorPrimaryDark,
                                          ],
                                          end: Alignment.bottomLeft,
                                          begin: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                      ),
                                      child: const MyText(
                                          color: white,
                                          text: "yes",
                                          multilanguage: true,
                                          textalign: TextAlign.center,
                                          fontsize: 16,
                                          inter: 1,
                                          maxline: 6,
                                          fontwaight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                          fontstyle: FontStyle.normal),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 100,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            colorPrimary,
                                            colorPrimaryDark,
                                          ],
                                          end: Alignment.bottomLeft,
                                          begin: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                      ),
                                      child: const MyText(
                                          color: white,
                                          text: "no",
                                          multilanguage: true,
                                          textalign: TextAlign.center,
                                          fontsize: 16,
                                          inter: 1,
                                          maxline: 6,
                                          fontwaight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                          fontstyle: FontStyle.normal),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      });
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
                child: Consumer<HomeProvider>(
                    builder: (context, valueupdateprovider, child) {
                  return MyText(
                    color: white,
                    multilanguage: true,
                    text: valueupdateprovider.uid.isEmpty ||
                            valueupdateprovider.uid == ""
                        ? "login"
                        : "logout",
                    fontwaight: FontWeight.w600,
                    fontsize: 18,
                    inter: 1,
                    fontstyle: FontStyle.normal,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                  );
                }),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const MyText(
              color: lightgray,
              text: "App Version : 3.2.1",
              fontwaight: FontWeight.w500,
              fontsize: 12,
              inter: 1,
              fontstyle: FontStyle.normal,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
          ],
        ),
      ),
    );
  }

// Home DrawerItem
  Widget drawerItem(String icon, String name, dynamic onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        height: MediaQuery.of(context).size.height * 0.08,
        child: Row(
          children: [
            MyImage(
              width: 30,
              height: 30,
              imagePath: icon,
              color: black,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            MyText(
                color: black,
                text: name,
                textalign: TextAlign.center,
                multilanguage: true,
                fontsize: 16,
                inter: 1,
                maxline: 2,
                fontwaight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
                fontstyle: FontStyle.normal),
          ],
        ),
      ),
    );
  }

// Grediant AppBar
  Widget homeappbar() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorPrimary,
            colorPrimaryDark,
          ],
          end: Alignment.bottomLeft,
          begin: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      ),
      child: Column(
        children: [
          AppBar(
            backgroundColor: transparent,
            elevation: 0,
            titleSpacing: 10,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const MyText(
                    color: white,
                    multilanguage: true,
                    text: "discover",
                    textalign: TextAlign.center,
                    fontsize: 22,
                    inter: 1,
                    maxline: 2,
                    fontwaight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    fontstyle: FontStyle.normal),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NotificationPage(userid: userid)));
                  },
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: white,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: white,
                        width: 2,
                      )),
                  child: Consumer<HomeProvider>(
                      builder: (context, valueupdateprovider, child) {
                    if (valueupdateprovider.uid.isEmpty ||
                        valueupdateprovider.uid == "") {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        },
                        child: MyImage(
                            width: 35,
                            height: 35,
                            imagePath: "ic_userprofile.png"),
                      );
                    } else {
                      return Consumer<ProfileProvider>(
                          builder: (context, profileprovider, child) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Profile()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: MyNetworkImage(
                                imgWidth: 35,
                                imgHeight: 35,
                                fit: BoxFit.cover,
                                imageUrl: profileprovider
                                        .profileModel.result?[0].image
                                        .toString() ??
                                    ""),
                          ),
                        );
                      });
                    }
                  }),
                ),
              ],
            ),
            centerTitle: false,
          ),
          const SizedBox(height: 5),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            alignment: Alignment.center,
            child: TextFormField(
              textAlign: TextAlign.left,
              keyboardType: TextInputType.text,
              readOnly: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const Search();
                    },
                  ),
                );
              },
              decoration: InputDecoration(
                prefixIcon: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: MyImage(
                    width: 20,
                    height: 20,
                    imagePath: "ic_search.png",
                    color: lightgray,
                  ),
                ),
                hintText: Constant.search,
                hintStyle: Utils.googleFontStyle(
                    1, 18, FontStyle.normal, lightgray, FontWeight.w400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                contentPadding: const EdgeInsets.all(10),
                fillColor: white,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Body
  Widget homebody() {
    return Column(
      children: [
        homeappbar(),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                banner(),
                category(),
                languageList(),
                allRadio(),
                city(),
                latestRadio(),
                rjAndArtist(),
                favouriteRadio(),
                ValueListenableBuilder(
                  valueListenable: currentlyPlaying,
                  builder: (BuildContext context, AudioPlayer? audioObject,
                      Widget? child) {
                    if (audioObject?.audioSource != null) {
                      return const SizedBox(height: 100);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

// Banner Section
  Widget banner() {
    return Consumer<HomeProvider>(builder: (context, bannerprovider, child) {
      if (bannerprovider.loading) {
        return bannerShimmer();
      } else {
        if (bannerprovider.bannerModel.status == 200 &&
            bannerprovider.bannerModel.result!.isNotEmpty) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.28,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.24,
                  child: PageView.builder(
                    itemCount: bannerprovider.bannerModel.result?.length ?? 0,
                    physics: const BouncingScrollPhysics(),
                    pageSnapping: true,
                    scrollDirection: Axis.horizontal,
                    controller: pagecontroller,
                    padEnds: false,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (userid.isEmpty || userid == "") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const Login();
                                },
                              ),
                            );
                          } else {
                            playAudio(
                                bannerprovider.bannerModel.result?[index].image
                                        .toString() ??
                                    "",
                                bannerprovider.bannerModel.result?[index].name
                                        .toString() ??
                                    "",
                                bannerprovider
                                        .bannerModel.result?[index].songUrl
                                        .toString() ??
                                    "",
                                bannerprovider
                                        .bannerModel.result?[index].languageName
                                        .toString() ??
                                    "",
                                bannerprovider
                                        .bannerModel.result?[index].artistName
                                        .toString() ??
                                    "",
                                bannerprovider.bannerModel.result?[index].id
                                        .toString() ??
                                    "",
                                index,
                                bannerprovider.bannerModel.result!.toList());
                          }
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, right: 7, left: 7),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: MyNetworkImage(
                                    fit: BoxFit.cover,
                                    imgWidth: MediaQuery.of(context).size.width,
                                    imgHeight:
                                        MediaQuery.of(context).size.height *
                                            0.24,
                                    imageUrl: bannerprovider
                                            .bannerModel.result?[index].image
                                            .toString() ??
                                        ""),
                              ),
                            ),
                            Positioned.fill(
                              bottom: 5,
                              left: 20,
                              right: 20,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 1, 5, 1),
                                        decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [colorAccent, orange],
                                              end: Alignment.bottomLeft,
                                              begin: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(02)),
                                        child: Center(
                                          child: MyText(
                                              color: white,
                                              text: bannerprovider
                                                      .bannerModel
                                                      .result?[index]
                                                      .languageName
                                                      .toString() ??
                                                  "",
                                              textalign: TextAlign.center,
                                              fontsize: 10,
                                              inter: 1,
                                              maxline: 2,
                                              fontwaight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis,
                                              fontstyle: FontStyle.normal),
                                        ),
                                      ),
                                      MyText(
                                          color: white,
                                          text: bannerprovider.bannerModel
                                                  .result?[index].name
                                                  .toString() ??
                                              "",
                                          textalign: TextAlign.center,
                                          fontsize: 20,
                                          inter: 1,
                                          maxline: 2,
                                          fontwaight: FontWeight.w700,
                                          overflow: TextOverflow.ellipsis,
                                          fontstyle: FontStyle.normal),
                                      MyText(
                                          color: white,
                                          text: bannerprovider.bannerModel
                                                  .result?[index].artistName
                                                  .toString() ??
                                              "",
                                          textalign: TextAlign.center,
                                          fontsize: 14,
                                          inter: 1,
                                          maxline: 2,
                                          fontwaight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                          fontstyle: FontStyle.normal),
                                    ],
                                  ),
                                  MyImage(
                                    imagePath: "ic_play.png",
                                    height: 35,
                                    width: 35,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                SmoothPageIndicator(
                  controller: pagecontroller,
                  count: bannerprovider.bannerModel.result?.length ?? 0,
                  effect: const ExpandingDotsEffect(
                    dotColor: lightgray,
                    activeDotColor: colorAccent,
                    dotHeight: 7,
                    dotWidth: 7,
                    strokeWidth: 4,
                    expansionFactor: 4,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

// Banner Section Shimmer
  Widget bannerShimmer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.28,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.24,
            child: PageView.builder(
              itemCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              pageSnapping: true,
              scrollDirection: Axis.horizontal,
              controller: pagecontroller,
              padEnds: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15, right: 7, left: 7),
                  child: CustomWidget.roundrectborder(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.24,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          SmoothPageIndicator(
            controller: pagecontroller,
            count: 2,
            effect: const ExpandingDotsEffect(
              dotColor: lightgray,
              activeDotColor: lightgray,
              dotHeight: 7,
              dotWidth: 7,
              strokeWidth: 4,
              expansionFactor: 4,
            ),
          ),
        ],
      ),
    );
  }

// Category Section
  Widget category() {
    return Consumer<HomeProvider>(builder: (context, categoryprovider, child) {
      if (categoryprovider.loading) {
        return categoryShimmer();
      } else {
        if (categoryprovider.categoryModel.status == 200 &&
            categoryprovider.categoryModel.result!.isNotEmpty) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyText(
                        color: black,
                        text: "category",
                        multilanguage: true,
                        textalign: TextAlign.center,
                        fontsize: 20,
                        inter: 1,
                        maxline: 2,
                        fontwaight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CategoryViewall(
                                userid: userid,
                              );
                            },
                          ),
                        );
                      },
                      child: const MyText(
                          color: colorAccent,
                          text: "viewall",
                          multilanguage: true,
                          textalign: TextAlign.center,
                          fontsize: 14,
                          inter: 1,
                          maxline: 2,
                          fontwaight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.13,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        categoryprovider.categoryModel.result?.length ?? 0,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return GetRadioByCategory(
                                    title: categoryprovider
                                            .categoryModel.result?[index].name
                                            .toString() ??
                                        "",
                                    userid: userid,
                                    categoryid: categoryprovider
                                            .categoryModel.result?[index].id
                                            .toString() ??
                                        "",
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.19,
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyNetworkImage(
                                  imgWidth: 45,
                                  imgHeight: 45,
                                  imageUrl: categoryprovider
                                          .categoryModel.result?[index].image
                                          .toString() ??
                                      "",
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(7, 0, 7, 0),
                                  child: MyText(
                                      color: black,
                                      text: categoryprovider
                                              .categoryModel.result?[index].name
                                              .toString() ??
                                          "",
                                      textalign: TextAlign.center,
                                      fontsize: 12,
                                      inter: 1,
                                      maxline: 1,
                                      fontwaight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                      fontstyle: FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

// Category Section Shimmer
  Widget categoryShimmer() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidget.roundrectborder(
                height: 20,
                width: 120,
              ),
              CustomWidget.roundrectborder(
                height: 20,
                width: 60,
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.13,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.19,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomWidget.rectangular(
                          height: 45,
                          width: 45,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        const CustomWidget.roundrectborder(
                          height: 10,
                          width: 45,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

// Language List
  Widget languageList() {
    return Consumer<HomeProvider>(builder: (context, languageprovider, child) {
      if (languageprovider.loading) {
        return languageShimmer();
      } else {
        if (languageprovider.languageModel.status == 200 &&
            languageprovider.languageModel.result!.isNotEmpty) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyText(
                        color: black,
                        text: "language",
                        textalign: TextAlign.center,
                        fontsize: 20,
                        inter: 1,
                        multilanguage: true,
                        maxline: 2,
                        fontwaight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LanguageViewAll(
                                userid: userid,
                              );
                            },
                          ),
                        );
                      },
                      child: const MyText(
                          color: colorAccent,
                          text: "viewall",
                          multilanguage: true,
                          textalign: TextAlign.center,
                          fontsize: 14,
                          inter: 1,
                          maxline: 2,
                          fontwaight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          languageprovider.languageModel.result?.length ?? 0,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return GetRadioByLanguage(
                                    title: languageprovider
                                            .languageModel.result?[index].name
                                            .toString() ??
                                        "",
                                    userid: userid,
                                    languageid: languageprovider
                                            .languageModel.result?[index].id
                                            .toString() ??
                                        "",
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: lightgray,
                            ),
                            child: MyText(
                                color: black,
                                text: languageprovider
                                        .languageModel.result?[index].name
                                        .toString() ??
                                    "",
                                textalign: TextAlign.center,
                                fontsize: 16,
                                inter: 1,
                                maxline: 2,
                                fontwaight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal),
                          ),
                        );
                      }),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

// Language Shimmer
  Widget languageShimmer() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidget.roundrectborder(
                height: 20,
                width: 120,
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.06,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return const CustomWidget.roundcorner(
                    height: 25,
                    width: 100,
                  );
                }),
          ),
        ),
      ],
    );
  }

// City
  Widget city() {
    return Consumer<HomeProvider>(builder: (context, cityprovider, child) {
      if (cityprovider.loading) {
        return cityShimmer();
      } else {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MyText(
                      color: black,
                      text: "city",
                      textalign: TextAlign.center,
                      fontsize: 20,
                      inter: 1,
                      multilanguage: true,
                      maxline: 2,
                      fontwaight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityViewAll(
                              userid: userid,
                            );
                          },
                        ),
                      );
                    },
                    child: const MyText(
                        color: colorAccent,
                        text: "viewall",
                        multilanguage: true,
                        textalign: TextAlign.center,
                        fontsize: 14,
                        inter: 1,
                        maxline: 2,
                        fontwaight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  itemCount: cityprovider.cityModel.result?.length ?? 0,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return GetRadioByCity(
                                title: cityprovider
                                        .cityModel.result?[index].name
                                        .toString() ??
                                    "",
                                userid: userid,
                                cityid: cityprovider.cityModel.result?[index].id
                                        .toString() ??
                                    "",
                              );
                            },
                          ),
                        );
                      },
                      radius: 60.0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: MyNetworkImage(
                                imgWidth: 90,
                                imageUrl: cityprovider
                                        .cityModel.result?[index].image
                                        .toString() ??
                                    "",
                                imgHeight: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.27,
                              child: MyText(
                                  color: black,
                                  inter: 1,
                                  text: cityprovider
                                          .cityModel.result?[index].name
                                          .toString() ??
                                      "",
                                  fontsize: 12,
                                  fontwaight: FontWeight.w600,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.center,
                                  fontstyle: FontStyle.normal),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }
    });
  }

// City Shimmer
  Widget cityShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: CustomWidget.roundrectborder(
                  height: 20,
                  width: 120,
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.19,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CustomWidget.circular(
                          width: 90,
                          height: 90,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.27,
                          child: const CustomWidget.roundrectborder(
                            width: 80,
                            height: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

// All Radio Section
  Widget allRadio() {
    return Consumer<HomeProvider>(builder: (context, allsongprovider, child) {
      if (allsongprovider.loading) {
        return allRadioShimmer();
      } else {
        if (allsongprovider.allSongsModel.status == 200 &&
            allsongprovider.allSongsModel.result!.isNotEmpty) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyText(
                        color: black,
                        text: "allradio",
                        textalign: TextAlign.center,
                        fontsize: 20,
                        multilanguage: true,
                        inter: 1,
                        maxline: 2,
                        fontwaight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AllRadioViewall(
                                title: "allradio",
                                userid: userid,
                              );
                            },
                          ),
                        );
                      },
                      child: const MyText(
                          color: colorAccent,
                          text: "viewall",
                          multilanguage: true,
                          textalign: TextAlign.center,
                          fontsize: 14,
                          inter: 1,
                          maxline: 2,
                          fontwaight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.20,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allsongprovider.allSongsModel.result?.length ?? 0,
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        playAudio(
                            allsongprovider.allSongsModel.result?[index].image
                                    .toString() ??
                                "",
                            allsongprovider.allSongsModel.result?[index].name
                                    .toString() ??
                                "",
                            allsongprovider.allSongsModel.result?[index].songUrl
                                    .toString() ??
                                "",
                            allsongprovider
                                    .allSongsModel.result?[index].languageName
                                    .toString() ??
                                "",
                            allsongprovider
                                    .allSongsModel.result?[index].artistName
                                    .toString() ??
                                "",
                            allsongprovider.allSongsModel.result?[index].id
                                    .toString() ??
                                "",
                            index,
                            allsongprovider.allSongsModel.result!.toList());
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: MyNetworkImage(
                                    imgWidth:
                                        MediaQuery.of(context).size.height *
                                            0.16,
                                    imgHeight:
                                        MediaQuery.of(context).size.height *
                                            0.16,
                                    imageUrl: allsongprovider
                                            .allSongsModel.result?[index].image
                                            .toString() ??
                                        "",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  right: 5,
                                  bottom: 5,
                                  child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: MyImage(
                                          width: 30,
                                          height: 30,
                                          imagePath: "ic_play.png")),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.16,
                              child: MyText(
                                  color: black,
                                  text: allsongprovider
                                          .allSongsModel.result?[index].name
                                          .toString() ??
                                      "",
                                  textalign: TextAlign.center,
                                  fontsize: 14,
                                  inter: 1,
                                  maxline: 1,
                                  fontwaight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

// All Radio Section Shimmer
  Widget allRadioShimmer() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidget.roundrectborder(
                height: 20,
                width: 120,
              ),
              CustomWidget.roundrectborder(
                height: 20,
                width: 60,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.22,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CustomWidget.rectangular(
                        width: MediaQuery.of(context).size.height * 0.14,
                        height: MediaQuery.of(context).size.height * 0.14,
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005),
                    const CustomWidget.roundrectborder(
                      width: 60,
                      height: 10,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005),
                    const CustomWidget.roundrectborder(
                      width: 60,
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

//Latest Radio Section
  Widget latestRadio() {
    return Consumer<HomeProvider>(
        builder: (context, latestradioprovider, child) {
      if (latestradioprovider.loading) {
        return latestRadioShimmer();
      } else {
        if (latestradioprovider.latestsongModel.status == 200 &&
            latestradioprovider.latestsongModel.result!.isNotEmpty) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyText(
                        color: black,
                        text: "latestradio",
                        multilanguage: true,
                        textalign: TextAlign.center,
                        fontsize: 20,
                        inter: 1,
                        maxline: 2,
                        fontwaight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LatestRadioViewAll(
                                  userid: userid, title: "latestradio");
                            },
                          ),
                        );
                      },
                      child: const MyText(
                          color: colorAccent,
                          text: "viewall",
                          multilanguage: true,
                          textalign: TextAlign.center,
                          fontsize: 14,
                          inter: 1,
                          maxline: 2,
                          fontwaight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.22,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  itemCount:
                      latestradioprovider.latestsongModel.result?.length ?? 0,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        playAudio(
                            latestradioprovider
                                    .latestsongModel.result?[index].image
                                    .toString() ??
                                "",
                            latestradioprovider
                                    .latestsongModel.result?[index].name
                                    .toString() ??
                                "",
                            latestradioprovider
                                    .latestsongModel.result?[index].songUrl
                                    .toString() ??
                                "",
                            latestradioprovider
                                    .latestsongModel.result?[index].languageName
                                    .toString() ??
                                "",
                            latestradioprovider
                                    .latestsongModel.result?[index].artistName
                                    .toString() ??
                                "",
                            latestradioprovider
                                    .latestsongModel.result?[index].id
                                    .toString() ??
                                "",
                            index,
                            latestradioprovider.latestsongModel.result!
                                .toList());
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: MyNetworkImage(
                                imgWidth:
                                    MediaQuery.of(context).size.height * 0.14,
                                imgHeight:
                                    MediaQuery.of(context).size.height * 0.14,
                                imageUrl: latestradioprovider
                                        .latestsongModel.result?[index].image
                                        .toString() ??
                                    "",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.14,
                              child: MyText(
                                  color: black,
                                  text: latestradioprovider
                                          .latestsongModel.result?[index].name
                                          .toString() ??
                                      "",
                                  textalign: TextAlign.left,
                                  fontsize: 14,
                                  inter: 1,
                                  maxline: 1,
                                  fontwaight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.14,
                              child: MyText(
                                  color: gray,
                                  text: latestradioprovider.latestsongModel
                                          .result?[index].categoryName
                                          .toString() ??
                                      "",
                                  textalign: TextAlign.left,
                                  fontsize: 12,
                                  inter: 1,
                                  maxline: 1,
                                  fontwaight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

// Latest Radio Secton Shimmer
  Widget latestRadioShimmer() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidget.roundrectborder(
                height: 20,
                width: 120,
              ),
              CustomWidget.roundrectborder(
                height: 20,
                width: 60,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.22,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CustomWidget.rectangular(
                        width: MediaQuery.of(context).size.height * 0.14,
                        height: MediaQuery.of(context).size.height * 0.14,
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005),
                    const CustomWidget.roundrectborder(
                      width: 60,
                      height: 10,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005),
                    const CustomWidget.roundrectborder(
                      width: 60,
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

// RJ And Artist
  Widget rjAndArtist() {
    return Consumer<HomeProvider>(builder: (context, artistprovider, child) {
      if (artistprovider.loading) {
        return artistShimmer();
      } else {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MyText(
                      color: black,
                      text: "rjandartist",
                      textalign: TextAlign.center,
                      fontsize: 20,
                      inter: 1,
                      multilanguage: true,
                      maxline: 2,
                      fontwaight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ArtistViewAll(
                              userid: userid,
                            );
                          },
                        ),
                      );
                    },
                    child: const MyText(
                        color: colorAccent,
                        text: "viewall",
                        multilanguage: true,
                        textalign: TextAlign.center,
                        fontsize: 14,
                        inter: 1,
                        maxline: 2,
                        fontwaight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.17,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: artistprovider.artistModel.result?.length,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return GetRadioByArtist(
                                  artistid: artistprovider
                                          .artistModel.result?[index].id
                                          .toString() ??
                                      "",
                                  userid: userid,
                                  title: artistprovider
                                          .artistModel.result?[index].name
                                          .toString() ??
                                      "");
                            },
                          ),
                        );
                      },
                      radius: 60.0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: MyNetworkImage(
                                imgWidth: 90,
                                imageUrl: artistprovider
                                        .artistModel.result?[index].image
                                        .toString() ??
                                    "",
                                imgHeight: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: MyText(
                                  color: black,
                                  inter: 1,
                                  text: artistprovider
                                          .artistModel.result?[index].name
                                          .toString() ??
                                      "",
                                  fontsize: 12,
                                  fontwaight: FontWeight.w600,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.center,
                                  fontstyle: FontStyle.normal),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }
    });
  }

  Widget artistShimmer() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: CustomWidget.roundrectborder(
                height: 20,
                width: 120,
              ),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.16,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: const CustomWidget.circular(
                          width: 90,
                          height: 90,
                        ),
                      ),
                      // SizedBox(
                      //     height: MediaQuery.of(context).size.height * 0.001),
                      CustomWidget.roundrectborder(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

// Favourite Radio Section
  Widget favouriteRadio() {
    return Consumer<HomeProvider>(builder: (context, favouriteprovider, child) {
      if (favouriteprovider.loading) {
        return favouriteRadioShimmer();
      } else {
        if (favouriteprovider.favouriteModel.status == 200 &&
            favouriteprovider.favouriteModel.result!.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyText(
                        color: black,
                        text: "favouriteradio",
                        textalign: TextAlign.center,
                        fontsize: 20,
                        inter: 1,
                        multilanguage: true,
                        maxline: 2,
                        fontwaight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Favourite(
                                userid: userid,
                              );
                            },
                          ),
                        );
                      },
                      child: const MyText(
                          color: colorAccent,
                          text: "viewall",
                          multilanguage: true,
                          textalign: TextAlign.center,
                          fontsize: 14,
                          inter: 1,
                          maxline: 2,
                          fontwaight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.23,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  itemCount:
                      favouriteprovider.favouriteModel.result?.length ?? 0,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        playAudio(
                            favouriteprovider
                                    .favouriteModel.result?[index].image
                                    .toString() ??
                                "",
                            favouriteprovider.favouriteModel.result?[index].name
                                    .toString() ??
                                "",
                            favouriteprovider
                                    .favouriteModel.result?[index].songUrl
                                    .toString() ??
                                "",
                            favouriteprovider
                                    .favouriteModel.result?[index].languageName
                                    .toString() ??
                                "",
                            favouriteprovider
                                    .favouriteModel.result?[index].artistName
                                    .toString() ??
                                "",
                            favouriteprovider.favouriteModel.result?[index].id
                                    .toString() ??
                                "",
                            index,
                            favouriteprovider.favouriteModel.result!.toList());
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: MyNetworkImage(
                                imgWidth:
                                    MediaQuery.of(context).size.height * 0.14,
                                imgHeight:
                                    MediaQuery.of(context).size.height * 0.14,
                                imageUrl: favouriteprovider
                                        .favouriteModel.result?[index].image
                                        .toString() ??
                                    "",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.14,
                              child: MyText(
                                  color: black,
                                  text: favouriteprovider
                                          .favouriteModel.result?[index].name
                                          .toString() ??
                                      "",
                                  textalign: TextAlign.left,
                                  fontsize: 14,
                                  inter: 1,
                                  maxline: 1,
                                  fontwaight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005),
                            MyText(
                                color: gray,
                                text: favouriteprovider.favouriteModel
                                        .result?[index].categoryName
                                        .toString() ??
                                    "",
                                textalign: TextAlign.left,
                                fontsize: 12,
                                inter: 1,
                                maxline: 2,
                                fontwaight: FontWeight.w400,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

// Favourite Radio Section Shimmer
  Widget favouriteRadioShimmer() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidget.roundrectborder(
                height: 20,
                width: 120,
              ),
              CustomWidget.roundrectborder(
                height: 20,
                width: 60,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.22,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CustomWidget.rectangular(
                        width: MediaQuery.of(context).size.height * 0.14,
                        height: MediaQuery.of(context).size.height * 0.14,
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005),
                    const CustomWidget.roundrectborder(
                      width: 60,
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

// Divider Line
  Widget divider() {
    return Container(
      color: lightgray,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      height: 1,
    );
  }

  exitDilog(BuildContext buildContext) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 16,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.28,
            decoration: BoxDecoration(
                color: white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyImage(
                  width: 70,
                  height: 70,
                  imagePath: "radio.png",
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 15),
                const MyText(
                  color: black,
                  text: "areyousurewanttoexit",
                  maxline: 1,
                  multilanguage: true,
                  fontwaight: FontWeight.w500,
                  fontsize: 16,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        exit(0);
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                colorPrimary,
                                colorPrimaryDark,
                              ],
                              end: Alignment.bottomLeft,
                              begin: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(50)),
                        child: const MyText(
                          color: white,
                          text: "done",
                          multilanguage: true,
                          maxline: 1,
                          fontwaight: FontWeight.w500,
                          fontsize: 14,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                colorPrimary,
                                colorPrimaryDark,
                              ],
                              end: Alignment.bottomLeft,
                              begin: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(50)),
                        child: const MyText(
                          color: white,
                          text: "cancel",
                          multilanguage: true,
                          maxline: 1,
                          fontwaight: FontWeight.w500,
                          fontsize: 14,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMusicPanel(context) {
    return ValueListenableBuilder(
      valueListenable: currentlyPlaying,
      builder: (BuildContext context, AudioPlayer? audioObject, Widget? child) {
        if (audioObject?.audioSource != null) {
          return const MusicDetails(
            ishomepage: true,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> playAudio(
    String imgurl,
    String title,
    String audiourl,
    String albumn,
    String discription,
    String audioid,
    int position,
    List sectionBannerList,
  ) async {
    _musicManager.setInitialPlaylist(position, sectionBannerList);
  }

  void changeLanguage(context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        barrierColor: white.withAlpha(1),
        backgroundColor: transparent,
        builder: (BuildContext bc) {
          return Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.30,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MyText(
                    color: black,
                    text: "changelanguage",
                    multilanguage: true,
                    textalign: TextAlign.center,
                    fontsize: 20,
                    inter: 1,
                    maxline: 6,
                    fontwaight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                    fontstyle: FontStyle.normal),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    LocaleNotifier.of(context)?.change('en');
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: const MyText(
                        color: black,
                        text: "english",
                        textalign: TextAlign.center,
                        fontsize: 16,
                        multilanguage: true,
                        inter: 1,
                        maxline: 6,
                        fontwaight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                  ),
                ),
                InkWell(
                  onTap: () {
                    LocaleNotifier.of(context)?.change('hi');
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: const MyText(
                        color: black,
                        text: "hindi",
                        textalign: TextAlign.center,
                        fontsize: 16,
                        inter: 1,
                        maxline: 6,
                        multilanguage: true,
                        fontwaight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                  ),
                ),
                InkWell(
                  focusColor: gray.withOpacity(0.40),
                  onTap: () {
                    LocaleNotifier.of(context)?.change('ar');
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: const MyText(
                        color: black,
                        text: "arebic",
                        textalign: TextAlign.center,
                        fontsize: 16,
                        multilanguage: true,
                        inter: 1,
                        maxline: 6,
                        fontwaight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                  ),
                ),
              ],
            ),
          );
        });
  }

  removeUseridFromLocal() async {
    await sharedpre.remove("userid");
  }
}
