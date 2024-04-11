import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:radioapp/pages/home.dart';
import 'package:radioapp/pages/musicdetails.dart';
import 'package:radioapp/pages/nodata.dart';
import 'package:radioapp/provider/searchprovider.dart';
import 'package:radioapp/utils/color.dart';
import 'package:radioapp/utils/constant.dart';
import 'package:radioapp/utils/customwidget.dart';
import 'package:radioapp/utils/musicmanager.dart';
import 'package:radioapp/utils/sharedpref.dart';
import 'package:radioapp/utils/utils.dart';
import 'package:radioapp/widget/myimage.dart';
import 'package:radioapp/widget/mynetworkimg.dart';
import 'package:radioapp/widget/mytext.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SharedPref sharedpre = SharedPref();
  String userid = "";
  var searchController = TextEditingController();
  final MusicManager _musicManager = MusicManager();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    userid = await sharedpre.read("userid") ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("clear provider");
    searchController.dispose();
    final searchprovider = Provider.of<SearchProvider>(context, listen: false);
    searchprovider.clearProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: lightwhite,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 0),
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
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
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
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: MyImage(
                            width: 15, height: 15, imagePath: "back.png"),
                      ),
                      title: const MyText(
                          color: white,
                          text: "search",
                          textalign: TextAlign.center,
                          fontsize: 22,
                          inter: 1,
                          maxline: 2,
                          fontwaight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                      centerTitle: true,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      alignment: Alignment.center,
                      child: TextFormField(
                        textAlign: TextAlign.left,
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        onChanged: (value) async {
                          final searchprovider = Provider.of<SearchProvider>(
                              context,
                              listen: false);
                          if (searchController.text.isNotEmpty ||
                              searchController.text != "") {
                            await searchprovider.getSearch(
                                userid, searchController.text.toString());
                          }
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
                          hintStyle: Utils.googleFontStyle(1, 18,
                              FontStyle.normal, lightgray, FontWeight.w400),
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
              ),
              Expanded(child: searchList()),
            ],
          ),
        ),
        buildMusicPanel(context),
      ],
    );
  }

  Widget searchList() {
    return Consumer<SearchProvider>(builder: (context, searchprovider, child) {
      if (searchprovider.loading) {
        return searchShimmer();
      } else {
        if (searchprovider.searchModel.status == 200 &&
            searchController.text.toString().isNotEmpty &&
            (searchprovider.searchModel.result?.length ?? 0) > 0 &&
            searchprovider.searchModel.result!.isNotEmpty) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: searchprovider.searchModel.result?.length ?? 0,
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    itemBuilder: (BuildContext ctx, index) {
                      return InkWell(
                        onTap: () {
                          playAudio(
                              searchprovider.searchModel.result?[index].image
                                      .toString() ??
                                  "",
                              searchprovider.searchModel.result?[index].name
                                      .toString() ??
                                  "",
                              searchprovider.searchModel.result?[index].songUrl
                                      .toString() ??
                                  "",
                              searchprovider
                                      .searchModel.result?[index].languageName
                                      .toString() ??
                                  "",
                              searchprovider
                                      .searchModel.result?[index].artistName
                                      .toString() ??
                                  "",
                              searchprovider.searchModel.result?[index].id
                                      .toString() ??
                                  "",
                              index,
                              searchprovider.searchModel.result!.toList());
                        },
                        child: Container(
                          height: 75,
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: MyNetworkImage(
                                  imgWidth: 65,
                                  imgHeight: 65,
                                  imageUrl: searchprovider
                                          .searchModel.result?[index].image
                                          .toString() ??
                                      "",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                        color: black,
                                        text: searchprovider
                                                .searchModel.result?[index].name
                                                .toString() ??
                                            "",
                                        textalign: TextAlign.start,
                                        fontsize: 16,
                                        inter: 1,
                                        maxline: 1,
                                        fontwaight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                        fontstyle: FontStyle.normal),
                                    MyText(
                                        color: lightgray,
                                        text: searchprovider.searchModel
                                                .result?[index].languageName
                                                .toString() ??
                                            "",
                                        textalign: TextAlign.start,
                                        fontsize: 14,
                                        inter: 1,
                                        maxline: 2,
                                        fontwaight: FontWeight.w400,
                                        overflow: TextOverflow.ellipsis,
                                        fontstyle: FontStyle.normal),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const NoData(
            text: "thereisnoradiochannels",
          );
        }
      }
    });
  }

  Widget searchShimmer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 10,
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            itemBuilder: (BuildContext ctx, index) {
              return Container(
                height: 75,
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const CustomWidget.circular(
                      width: 65,
                      height: 65,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidget.roundrectborder(
                            width: MediaQuery.of(context).size.width * 0.50,
                            height: 15,
                          ),
                          CustomWidget.roundrectborder(
                            width: MediaQuery.of(context).size.width * 0.20,
                            height: 15,
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
      ],
    );
  }

  Widget buildMusicPanel(context) {
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
}
