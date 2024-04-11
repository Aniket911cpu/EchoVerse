import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:echoverse/provider/notificationprovider.dart';
import 'package:echoverse/utils/color.dart';
import 'package:echoverse/utils/customwidget.dart';
import 'package:echoverse/utils/sharedpref.dart';
import 'package:echoverse/utils/utils.dart';
import 'package:echoverse/widget/myappbar.dart';
import 'package:echoverse/widget/mynetworkimg.dart';
import 'package:echoverse/widget/mytext.dart';
import 'package:readmore/readmore.dart';

class NotificationPage extends StatefulWidget {
  final String userid;
  const NotificationPage({super.key, required this.userid});

  @override
  State<NotificationPage> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  SharedPref sharedpre = SharedPref();
  String userid = "";

  @override
  void initState() {
    super.initState();
    getApi();
  }

  getApi() async {
    final notificationprovider =
        Provider.of<NotificationProvider>(context, listen: false);
    // userid = await sharedpre.read("userid");

    await notificationprovider.getNotification(widget.userid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightwhite,
      body: Column(
        children: [
          MyAppbar(
            title: "notification",
            icon: "back.png",
            isSimpleappbar: 1,
            onBack: () {
              Navigator.pop(context);
            },
          ),
          Expanded(child: notificationlist()),
        ],
      ),
    );
  }

  Widget notificationlist() {
    return Consumer<NotificationProvider>(
        builder: (context, notificationprovider, child) {
      if (notificationprovider.loading) {
        return notificationlistShimmer();
      } else {
        if (notificationprovider.notificationModel.status == 200 &&
            notificationprovider.notificationModel.result!.isNotEmpty) {
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount:
                  notificationprovider.notificationModel.result?.length ?? 0,
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: MyNetworkImage(
                            imgWidth: 55,
                            imgHeight: 55,
                            imageUrl: notificationprovider
                                    .notificationModel.result?[index].image
                                    .toString() ??
                                "",
                            fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                color: black,
                                text: notificationprovider
                                        .notificationModel.result?[index].title
                                        .toString() ??
                                    "",
                                fontsize: 14,
                                maxline: 2,
                                inter: 3,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal,
                                fontwaight: FontWeight.w500),
                            const SizedBox(height: 5),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.centerLeft,
                              child: ReadMoreText(
                                notificationprovider.notificationModel
                                        .result?[index].description
                                        .toString() ??
                                    "",
                                trimLines: 5,
                                preDataTextStyle: Utils.googleFontStyle(3, 12,
                                    FontStyle.normal, gray, FontWeight.w400),
                                style: Utils.googleFontStyle(3, 12,
                                    FontStyle.normal, gray, FontWeight.w400),
                                colorClickableText: red,
                                trimMode: TrimMode.Line,
                                textAlign: TextAlign.start,
                                trimCollapsedText: '  Read More',
                                trimExpandedText: ' Read less',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return Utils().noData(context, "Notification is Empty");
        }
      }
    });
  }

  Widget notificationlistShimmer() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 10,
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                const CustomWidget.circular(
                  width: 55,
                  height: 55,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomWidget.roundrectborder(
                        width: MediaQuery.of(context).size.width * 0.40,
                        height: 10,
                      ),
                      const SizedBox(height: 5),
                      CustomWidget.roundrectborder(
                        width: MediaQuery.of(context).size.width * 0.20,
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
