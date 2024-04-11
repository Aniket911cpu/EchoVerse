import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:echoverse/pages/home.dart';
import 'package:echoverse/pages/login.dart';
import 'package:echoverse/pages/musicdetails.dart';
import 'package:echoverse/pages/nodata.dart';
import 'package:echoverse/provider/favouriteprovider.dart';
import 'package:echoverse/utils/color.dart';
import 'package:echoverse/utils/customwidget.dart';
import 'package:echoverse/utils/musicmanager.dart';
import 'package:echoverse/utils/utils.dart';
import 'package:echoverse/widget/myappbar.dart';
import 'package:echoverse/widget/mynetworkimg.dart';
import 'package:echoverse/widget/mytext.dart';

import '../model/favouritelmodel.dart';

class Favourite extends StatefulWidget {
  final String userid;
  const Favourite({super.key, required this.userid});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  late PagewiseLoadController<Result> _pageLoadController;
  int pageno = 1;
  final MusicManager _musicManager = MusicManager();

  @override
  void initState() {
    super.initState();
    debugPrint("userid=>${widget.userid}");
    getApi();
  }

  getApi() async {
    _pageLoadController =
        PagewiseLoadController(pageSize: 10, pageFuture: fetchAllSongNewData);
  }

  Future<List<Result>> fetchAllSongNewData(int? nextPage) async {
    final favouriteprovider =
        Provider.of<FavouriteProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await favouriteprovider.getFavourite(widget.userid, pageno.toString());
    return favouriteprovider.favouriteModel.result!;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              MyAppbar(
                title: "favouritesradio",
                icon: "back.png",
                isSimpleappbar: 1,
                onBack: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: favouriteList(),
              ),
            ],
          ),
        ),
        buildMusicPanel(context),
      ],
    );
  }

  Widget favouriteList() {
    return Consumer<FavouriteProvider>(
        builder: (context, favouriteprovider, child) {
      if (favouriteprovider.loading) {
        return favouriteShimmer();
      } else {
        return PagewiseListView(
          pageLoadController: _pageLoadController,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          noItemsFoundBuilder: (context) {
            return const NoData(
              text: "thereisnoradiochannels",
            );
          },
          addRepaintBoundaries: true,
          addAutomaticKeepAlives: true,
          addSemanticIndexes: true,
          loadingBuilder: (context) {
            return Utils.pageLoader();
          },
          itemBuilder: (context, entry, index) {
            return InkWell(
              onTap: () {
                // Song Play
                if (widget.userid.isEmpty || widget.userid == "") {
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
                      entry.image.toString(),
                      entry.name.toString(),
                      entry.songUrl.toString(),
                      entry.languageName.toString(),
                      entry.artistName.toString(),
                      entry.id.toString(),
                      index,
                      favouriteprovider.favouriteModel.result?.toList() ?? []);
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 75,
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
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
                        imageUrl: entry.image.toString(),
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
                              text: entry.name.toString(),
                              textalign: TextAlign.start,
                              fontsize: 16,
                              inter: 1,
                              maxline: 2,
                              fontwaight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal),
                          MyText(
                              color: lightgray,
                              text: entry.languageName.toString(),
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
        );
      }
    });
  }

  Widget favouriList() {
    return Consumer<FavouriteProvider>(
        builder: (context, favouriteprovider, child) {
      if (favouriteprovider.loading) {
        return favouriteShimmer();
      } else {
        if (favouriteprovider.favouriteModel.status == 200 &&
            favouriteprovider.favouriteModel.result!.isNotEmpty) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Column(
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
                        itemCount:
                            favouriteprovider.favouriteModel.result?.length ??
                                0,
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        itemBuilder: (BuildContext ctx, index) {
                          return InkWell(
                            onTap: () {
                              // Song Play
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
                                      imageUrl: favouriteprovider.favouriteModel
                                              .result?[index].image
                                              .toString() ??
                                          "",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                            color: black,
                                            text: favouriteprovider
                                                    .favouriteModel
                                                    .result?[index]
                                                    .name
                                                    .toString() ??
                                                "",
                                            textalign: TextAlign.start,
                                            fontsize: 16,
                                            inter: 1,
                                            maxline: 2,
                                            fontwaight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                            fontstyle: FontStyle.normal),
                                        MyText(
                                            color: lightgray,
                                            text: favouriteprovider
                                                    .favouriteModel
                                                    .result?[index]
                                                    .languageName
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

  Widget favouriteShimmer() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Column(
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
                          const CustomWidget.circular(width: 65, height: 65),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                CustomWidget.roundrectborder(
                                    width: 100, height: 12),
                                CustomWidget.roundrectborder(
                                    width: 100, height: 12),
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
          ),
        ],
      ),
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
