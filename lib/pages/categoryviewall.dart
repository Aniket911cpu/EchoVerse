import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:provider/provider.dart';
import 'package:radioapp/pages/getradiobycategory.dart';
import 'package:radioapp/pages/nodata.dart';
import 'package:radioapp/provider/categoryviewallprovider.dart';
import 'package:radioapp/utils/color.dart';
import 'package:radioapp/utils/customwidget.dart';
import 'package:radioapp/utils/utils.dart';
import 'package:radioapp/widget/myappbar.dart';
import 'package:radioapp/widget/mynetworkimg.dart';
import 'package:radioapp/widget/mytext.dart';

import '../model/categorymodel.dart';

class CategoryViewall extends StatefulWidget {
  final String userid;
  const CategoryViewall({super.key, required this.userid});

  @override
  State<CategoryViewall> createState() => _CategoryViewallState();
}

class _CategoryViewallState extends State<CategoryViewall> {
  late PagewiseLoadController<Result> _pageLoadController;
  int pageno = 1;

  @override
  initState() {
    super.initState();
    getApi();
  }

  getApi() async {
    _pageLoadController =
        PagewiseLoadController(pageSize: 10, pageFuture: fetchNewData);
  }

  Future<List<Result>> fetchNewData(int? nextPage) async {
    final categoryprovider =
        Provider.of<CategoryViewAllProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await categoryprovider.getCategory(pageno.toString());
    return categoryprovider.categoryModel.result!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightwhite,
      body: Column(
        children: [
          MyAppbar(
            title: "category",
            isSimpleappbar: 1,
            icon: "back.png",
            onBack: () {
              Navigator.pop(context);
            },
          ),
          Expanded(child: categorylist()),
        ],
      ),
    );
  }

  Widget categorylist() {
    return Consumer<CategoryViewAllProvider>(
        builder: (context, categoryprovider, child) {
      if (categoryprovider.loading) {
        return categorylistShimmer();
      } else {
        return PagewiseGridView<Result>.count(
          crossAxisCount: 4,
          pageLoadController: _pageLoadController,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          noItemsFoundBuilder: (context) {
            return const NoData(
              text: "thereisnoradiochannels",
            );
          },
          childAspectRatio: 4 / 5,
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
            return categorylistItem(index, entry);
          },
        );
      }
    });
  }

  Widget categorylistItem(int position, Result categorylist) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return GetRadioByCategory(
                title: categorylist.name.toString(),
                userid: widget.userid,
                categoryid: categorylist.id.toString(),
              );
            },
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.19,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
            color: white, borderRadius: BorderRadius.circular(25)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyNetworkImage(
              imgWidth: 45,
              imgHeight: 45,
              imageUrl: categorylist.image.toString(),
              fit: BoxFit.fill,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: MyText(
                  color: black,
                  text: categorylist.name.toString(),
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
    );
  }

  Widget categorylistShimmer() {
    return Column(
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
              itemCount: 24,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 4 / 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (BuildContext ctx, index) {
                return CustomWidget.roundcorner(
                  width: MediaQuery.of(context).size.width * 0.19,
                  height: MediaQuery.of(context).size.height * 0.15,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
