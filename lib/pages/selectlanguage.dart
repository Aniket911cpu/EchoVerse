import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radioapp/pages/home.dart';
import 'package:radioapp/provider/languageprovider.dart';
import 'package:radioapp/utils/color.dart';
import 'package:radioapp/utils/customwidget.dart';
import 'package:radioapp/utils/sharedpref.dart';
import 'package:radioapp/utils/utils.dart';
import 'package:radioapp/widget/mytext.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  SharedPref sharedPre = SharedPref();
  bool isvisible = false;
  final List<int> selectedlanguage = [];
  List storeid = [];

  @override
  void initState() {
    super.initState();
    getApi();
  }

  getApi() async {
    final languageprovider =
        Provider.of<LanguageProvider>(context, listen: false);
    await languageprovider.getLanguage("0");
  }

  @override
  void dispose() {
    super.dispose();
    selectedlanguage.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightwhite,
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back.png'),
              ),
            ),
          ),
        ),
        title: const MyText(
          color: black,
          text: "selectlanguage",
          multilanguage: true,
          textalign: TextAlign.center,
          fontsize: 24,
          inter: 1,
          maxline: 1,
          fontwaight: FontWeight.w600,
          overflow: TextOverflow.ellipsis,
          fontstyle: FontStyle.normal,
        ),
      ),
      body: languageList(),
    );
  }

  Widget languageList() {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Column(
              children: [
                const MyText(
                    color: gray,
                    text:
                        "Lorem ipsum dolor sit amet consectetur \n adipicing edit",
                    textalign: TextAlign.center,
                    fontsize: 14,
                    inter: 1,
                    maxline: 2,
                    fontwaight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    fontstyle: FontStyle.normal),
                Consumer<LanguageProvider>(
                    builder: (context, languageprovider, child) {
                  if (languageprovider.loading) {
                    return languageShimmer();
                  } else {
                    if (languageprovider.languageModel.status == 200 &&
                        languageprovider.languageModel.result!.isNotEmpty) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        alignment: Alignment.topCenter,
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount:
                                languageprovider.languageModel.result?.length ??
                                    0,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 5 / 6,
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                            itemBuilder: (BuildContext ctx, index) {
                              return InkWell(
                                onTap: () async {
                                  if (selectedlanguage.contains(index)) {
                                    log("unselectindex==>$index");
                                    setState(() {
                                      selectedlanguage
                                          .removeWhere((val) => val == index);

                                      storeid.removeWhere((val) =>
                                          val ==
                                          languageprovider
                                              .languageModel.result?[index].id
                                              .toString());

                                      if (selectedlanguage.isEmpty) {
                                        isvisible = false;
                                      }
                                    });
                                  } else {
                                    log("selectindex==>$index");
                                    setState(() {
                                      isvisible = true;
                                      selectedlanguage.add(index);
                                      storeid.add(languageprovider
                                              .languageModel.result?[index].id
                                              .toString() ??
                                          "");
                                    });
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.27,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.13,
                                      decoration: BoxDecoration(
                                          color:
                                              selectedlanguage.contains(index)
                                                  ? red
                                                  : white,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            MyText(
                                              color: selectedlanguage
                                                      .contains(index)
                                                  ? white
                                                  : black,
                                              text: languageprovider
                                                      .languageModel
                                                      .result?[index]
                                                      .name
                                                      .toString() ??
                                                  "",
                                              textalign: TextAlign.center,
                                              fontsize: 16,
                                              inter: 1,
                                              maxline: 1,
                                              fontwaight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                              fontstyle: FontStyle.normal,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return Utils().noData(context, "languageisempty");
                    }
                  }
                }),
              ],
            ),
          ),
        ),
        Positioned.fill(
          bottom: 25,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () async {
                var mergelanguageid = storeid.join(",");
                debugPrint("languageid=> $mergelanguageid");
                if (mergelanguageid.isEmpty) {
                  Utils.showSnackbar(context, "pleaseselectlanguage", true);
                } else {
                  await sharedPre.save("seen", "1");
                  await sharedPre.save(
                      "languageid", mergelanguageid.toString());

                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Home();
                      },
                    ),
                  );
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.55,
                height: MediaQuery.of(context).size.height * 0.065,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(colors: [
                    colorPrimary,
                    colorPrimaryDark,
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                ),
                child: const MyText(
                  color: white,
                  text: "Continue",
                  textalign: TextAlign.center,
                  fontsize: 18,
                  inter: 1,
                  maxline: 1,
                  fontwaight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget languageShimmer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      alignment: Alignment.topCenter,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 15,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 5 / 6,
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5),
          itemBuilder: (BuildContext ctx, index) {
            return Column(
              children: [
                CustomWidget.circular(
                  width: MediaQuery.of(context).size.width * 0.27,
                  height: MediaQuery.of(context).size.height * 0.13,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
