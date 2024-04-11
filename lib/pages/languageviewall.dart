import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:provider/provider.dart';
import 'package:echoverse/pages/getradiobylanguage.dart';
import 'package:echoverse/pages/nodata.dart';
import 'package:echoverse/provider/languageviewallprovider.dart';
import 'package:echoverse/utils/color.dart';
import 'package:echoverse/utils/customwidget.dart';
import 'package:echoverse/utils/utils.dart';
import 'package:echoverse/widget/myappbar.dart';
import 'package:echoverse/widget/mytext.dart';

import '../model/languagemodel.dart';

class LanguageViewAll extends StatefulWidget {
  final String userid;
  const LanguageViewAll({super.key, required this.userid});

  @override
  State<LanguageViewAll> createState() => _LanguageViewAllState();
}

class _LanguageViewAllState extends State<LanguageViewAll> {
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
    final languageprovider =
        Provider.of<LanguageViewAllProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await languageprovider.getLanguage(pageno.toString());
    return languageprovider.languageModel.result!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightwhite,
      body: Column(
        children: [
          MyAppbar(
            title: "language",
            isSimpleappbar: 1,
            icon: "back.png",
            onBack: () {
              Navigator.pop(context);
            },
          ),
          Expanded(child: languagelist()),
        ],
      ),
    );
  }

  Widget languagelist() {
    return Consumer<LanguageViewAllProvider>(
        builder: (context, languageprovider, child) {
      if (languageprovider.loading) {
        return languageviewallShimmer();
      } else {
        return PagewiseGridView<Result>.count(
          crossAxisCount: 3,
          pageLoadController: _pageLoadController,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 5 / 2,
          noItemsFoundBuilder: (context) {
            return const NoData(
              text: "thereisnoradiochannels",
            );
          },
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          addRepaintBoundaries: true,
          addAutomaticKeepAlives: true,
          addSemanticIndexes: true,
          loadingBuilder: (context) {
            return Utils.pageLoader();
          },
          itemBuilder: (context, entry, index) {
            return languagelistItem(index, entry);
          },
        );
      }
    });
  }

  Widget languagelistItem(int position, Result languagelist) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return GetRadioByLanguage(
                title: languagelist.name.toString(),
                userid: widget.userid,
                languageid: languagelist.id.toString(),
              );
            },
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: lightgray,
        ),
        child: MyText(
            color: black,
            text: languagelist.name.toString(),
            textalign: TextAlign.center,
            fontsize: 14,
            inter: 1,
            maxline: 1,
            fontwaight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
            fontstyle: FontStyle.normal),
      ),
    );
  }

  Widget languageviewallShimmer() {
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
