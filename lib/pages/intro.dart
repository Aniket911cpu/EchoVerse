import 'package:flutter/material.dart';
import 'package:radioapp/pages/selectlanguage.dart';
import 'package:radioapp/utils/color.dart';
import 'package:radioapp/utils/sharedpref.dart';
import 'package:radioapp/widget/myimage.dart';
import 'package:radioapp/widget/mytext.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  SharedPref sharedPre = SharedPref();
  PageController pageController = PageController();
  int position = 0;

  List<String> introImage = [
    "ic_intro1.png",
    "ic_intro2.png",
    "ic_intro3.png",
  ];

  List<String> introMainText = [
    "welcometoradio",
    "welcometoradio",
    "welcometoradio",
  ];

  List<String> introChildText = [
    "Lörem ipsum sanat. Reana pan. Aliga kapselbryggare astrofesm. Plaras syjonyre nisk. Luskap monojossade om degen. Liguktig geotilogi då eul. Tiheten tejarad premägen dyspatologi. Infranade. Tidat.Danseoke antesepede innan memyna och varen. Manade decir för fåkulig. Endomani myrtad fastän kalsongbombare predade.",
    "Lörem ipsum sanat. Reana pan. Aliga kapselbryggare astrofesm. Plaras syjonyre nisk. Luskap monojossade om degen. Liguktig geotilogi då eul. Tiheten tejarad premägen dyspatologi. Infranade. Tidat.Danseoke antesepede innan memyna och varen. Manade decir för fåkulig. Endomani myrtad fastän kalsongbombare predade.",
    "Lörem ipsum sanat. Reana pan. Aliga kapselbryggare astrofesm. Plaras syjonyre nisk. Luskap monojossade om degen. Liguktig geotilogi då eul. Tiheten tejarad premägen dyspatologi. Infranade. Tidat.Danseoke antesepede innan memyna och varen. Manade decir för fåkulig. Endomani myrtad fastän kalsongbombare predade.",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: PageView.builder(
                    itemCount: introImage.length,
                    controller: pageController,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          MyImage(
                            imagePath: introImage[index],
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.55,
                          ),
                          MyText(
                              color: colorAccent,
                              text: introMainText[position],
                              textalign: TextAlign.center,
                              fontsize: 20,
                              inter: 1,
                              maxline: 2,
                              multilanguage: true,
                              fontwaight: FontWeight.w300,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          MyText(
                              color: colorAccent,
                              text: introChildText[position],
                              textalign: TextAlign.center,
                              fontsize: 12,
                              inter: 2,
                              maxline: 6,
                              fontwaight: FontWeight.w300,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal),
                        ],
                      );
                    },
                    onPageChanged: (value) {
                      position = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Positioned.fill(
              bottom: 80,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () async {
                    if (position == introImage.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const SelectLanguage();
                          },
                        ),
                      );
                    } else {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.07,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const MyText(
                        color: white,
                        text: "getstart",
                        fontsize: 16,
                        multilanguage: true,
                        fontwaight: FontWeight.w500,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        inter: 1,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              bottom: 30,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const SelectLanguage();
                        },
                      ),
                    );
                  },
                  child: MyText(
                      color: black,
                      text:
                          position == introImage.length - 1 ? "finish" : "skip",
                      textalign: TextAlign.center,
                      fontsize: 16,
                      multilanguage: true,
                      inter: 1,
                      fontwaight: FontWeight.w300,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
