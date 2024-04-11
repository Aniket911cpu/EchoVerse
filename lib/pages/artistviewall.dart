import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:provider/provider.dart';
import 'package:radioapp/model/artistmodel.dart';
import 'package:radioapp/pages/getradiobyartist.dart';
import 'package:radioapp/pages/nodata.dart';
import 'package:radioapp/provider/artistviewallprovider.dart';
import 'package:radioapp/utils/color.dart';
import 'package:radioapp/utils/customwidget.dart';
import 'package:radioapp/utils/utils.dart';
import 'package:radioapp/widget/myappbar.dart';
import 'package:radioapp/widget/mynetworkimg.dart';
import 'package:radioapp/widget/mytext.dart';

class ArtistViewAll extends StatefulWidget {
  final String userid;
  const ArtistViewAll({super.key, required this.userid});

  @override
  State<ArtistViewAll> createState() => _ArtistViewAllState();
}

class _ArtistViewAllState extends State<ArtistViewAll> {
  late PagewiseLoadController<Result> _pageLoadController;
  int pageno = 1;

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
    final artistprovider =
        Provider.of<ArtistViewAllProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await artistprovider.getArtist(pageno.toString());
    return artistprovider.artistModel.result!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightwhite,
      body: Column(
        children: [
          MyAppbar(
            title: "rjartist",
            isSimpleappbar: 1,
            icon: "back.png",
            onBack: () {
              Navigator.pop(context);
            },
          ),
          Expanded(child: artistlist()),
        ],
      ),
    );
  }

  Widget artistlist() {
    return Consumer<ArtistViewAllProvider>(
        builder: (context, cityprovider, child) {
      if (cityprovider.loading) {
        return artistShimmer();
      } else {
        return PagewiseGridView<Result>.count(
          crossAxisCount: 3,
          pageLoadController: _pageLoadController,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 5 / 6,
          shrinkWrap: true,
          noItemsFoundBuilder: (context) {
            return const NoData(
              text: "thereisnoradiochannels",
            );
          },
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          addRepaintBoundaries: true,
          addAutomaticKeepAlives: true,
          addSemanticIndexes: true,
          loadingBuilder: (context) {
            return Utils.pageLoader();
          },
          itemBuilder: (context, entry, index) {
            return artistlistItem(index, entry);
          },
        );
      }
    });
  }

  Widget artistlistItem(int position, Result languagelist) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return GetRadioByArtist(
                  artistid: languagelist.id.toString(),
                  userid: widget.userid,
                  title: languagelist.name.toString());
            },
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: MyNetworkImage(
              imgWidth: 90,
              imageUrl: languagelist.image.toString(),
              imgHeight: 90,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.25,
            child: MyText(
                color: black,
                inter: 1,
                text: languagelist.name.toString(),
                fontsize: 12,
                fontwaight: FontWeight.w600,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal),
          ),
        ],
      ),
    );
  }

  Widget artistShimmer() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
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
                  itemCount: 15,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 5 / 6,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemBuilder: (BuildContext ctx, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CustomWidget.circular(
                          width: 90,
                          height: 90,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005),
                        CustomWidget.roundrectborder(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 10,
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
