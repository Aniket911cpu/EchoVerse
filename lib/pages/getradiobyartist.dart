import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:radioapp/pages/home.dart';
import 'package:radioapp/pages/musicdetails.dart';
import 'package:radioapp/pages/nodata.dart';
import 'package:radioapp/provider/getradiobyartistprovider.dart';
import 'package:radioapp/utils/color.dart';
import 'package:radioapp/utils/customwidget.dart';
import 'package:radioapp/utils/musicmanager.dart';
import 'package:radioapp/utils/utils.dart';
import 'package:radioapp/widget/myappbar.dart';
import 'package:radioapp/widget/mynetworkimg.dart';
import 'package:radioapp/widget/mytext.dart';

import '../model/getradiobyartistmodel.dart';

class GetRadioByArtist extends StatefulWidget {
  final String title, userid, artistid;
  const GetRadioByArtist({
    super.key,
    required this.title,
    required this.userid,
    required this.artistid,
  });

  @override
  State<GetRadioByArtist> createState() => _GetRadioByArtistState();
}

class _GetRadioByArtistState extends State<GetRadioByArtist> {
  late PagewiseLoadController<Result> _pageLoadController;
  int pageno = 1;
  final MusicManager _musicManager = MusicManager();

  @override
  void initState() {
    super.initState();
    getApi();
  }

  getApi() async {
    _pageLoadController =
        PagewiseLoadController(pageSize: 10, pageFuture: fetchNewData);
  }

  Future<List<Result>> fetchNewData(int? nextPage) async {
    final radiobyartistprovider =
        Provider.of<GetRadiobyArtistProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await radiobyartistprovider.getRadiobyArtist(
        widget.artistid, pageno.toString());
    return radiobyartistprovider.getradiobyartistModel.result!;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: lightwhite,
          body: Column(
            children: [
              MyAppbar(
                isSimpleappbar: 3,
                title: widget.title.toString(),
                icon: "back.png",
                onBack: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(child: getradiobyartistlist()),
            ],
          ),
        ),
        buildMusicPanel(context),
      ],
    );
  }

  Widget getradiobyartistlist() {
    return Consumer<GetRadiobyArtistProvider>(
        builder: (context, getradiobyartistprovider, child) {
      if (getradiobyartistprovider.loading) {
        return artistShimmer();
      } else {
        return PagewiseGridView<Result>.count(
          crossAxisCount: 3,
          pageLoadController: _pageLoadController,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 5 / 9,
          shrinkWrap: true,
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
                playAudio(
                    entry.image.toString(),
                    entry.name.toString(),
                    entry.songUrl.toString(),
                    entry.languageName.toString(),
                    entry.artistName.toString(),
                    entry.id.toString(),
                    index,
                    getradiobyartistprovider.getradiobyartistModel.result!
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
                        imgWidth: MediaQuery.of(context).size.height * 0.14,
                        imgHeight: MediaQuery.of(context).size.height * 0.14,
                        imageUrl: entry.image.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005),
                    SizedBox(
                      width: MediaQuery.of(context).size.height * 0.14,
                      child: MyText(
                          color: black,
                          text: entry.name.toString(),
                          textalign: TextAlign.left,
                          fontsize: 14,
                          inter: 1,
                          maxline: 1,
                          fontwaight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005),
                    SizedBox(
                      width: MediaQuery.of(context).size.height * 0.14,
                      child: MyText(
                          color: gray,
                          text: entry.categoryName.toString(),
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
        );
      }
    });
  }

  Widget artistShimmer() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
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
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 5 / 9,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5),
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: CustomWidget.rectangular(
                            width: MediaQuery.of(context).size.height * 0.14,
                            height: MediaQuery.of(context).size.height * 0.14,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005),
                        const CustomWidget.roundrectborder(
                          width: 80,
                          height: 10,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.002),
                        const CustomWidget.roundrectborder(
                          width: 50,
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
