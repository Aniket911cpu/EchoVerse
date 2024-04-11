import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:provider/provider.dart';
import 'package:echoverse/pages/getradiobycity.dart';
import 'package:echoverse/pages/nodata.dart';
import 'package:echoverse/provider/cityviewallprovider.dart';
import 'package:echoverse/utils/color.dart';
import 'package:echoverse/utils/customwidget.dart';
import 'package:echoverse/utils/utils.dart';
import 'package:echoverse/widget/myappbar.dart';
import 'package:echoverse/widget/mynetworkimg.dart';
import 'package:echoverse/widget/mytext.dart';

import '../model/citymodel.dart';

class CityViewAll extends StatefulWidget {
  final String userid;
  const CityViewAll({super.key, required this.userid});

  @override
  State<CityViewAll> createState() => CityViewAllState();
}

class CityViewAllState extends State<CityViewAll> {
  late PagewiseLoadController<Result> _pageLoadController;
  int? pageno = 1;
  late CityViewAllProvider cityviewallprovider;

  @override
  void initState() {
    cityviewallprovider =
        Provider.of<CityViewAllProvider>(context, listen: false);
    super.initState();

    getApi();
  }

  getApi() async {
    _pageLoadController =
        PagewiseLoadController(pageSize: 10, pageFuture: fetchNewData);
  }

  Future<List<Result>> fetchNewData(int? nextPage) async {
    await cityviewallprovider.getCity((nextPage ?? 0) + 1);
    pageno = nextPage;
    return cityviewallprovider.cityModel.result ?? [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightwhite,
      body: Column(
        children: [
          MyAppbar(
            title: "city",
            isSimpleappbar: 1,
            icon: "back.png",
            onBack: () {
              Navigator.pop(context);
            },
          ),
          Expanded(child: bodypage()),
        ],
      ),
    );
  }

  Widget bodypage() {
    return PagewiseGridView<Result>.count(
      pageLoadController: _pageLoadController,
      crossAxisCount: 3,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      childAspectRatio: 5 / 6,
      physics: const BouncingScrollPhysics(),
      noItemsFoundBuilder: (context) {
        return const NoData(
          text: "thereisnoradiochannels",
        );
      },
      loadingBuilder: (context) {
        return Utils.pageLoader();
      },
      shrinkWrap: true,
      padding: const EdgeInsets.all(15.0),
      itemBuilder: (context, entry, index) {
        return builditem(index, entry);
      },
    );
  }

  Widget builditem(int position, Result citylist) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return GetRadioByCity(
                  cityid: citylist.id.toString(),
                  userid: widget.userid,
                  title: citylist.name.toString());
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
              imageUrl: citylist.image ?? "",
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
                text: citylist.name ?? "",
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

  Widget cityviewallShimmer() {
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
