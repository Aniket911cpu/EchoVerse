import 'package:flutter/material.dart';
import 'package:radioapp/utils/color.dart';
import 'package:radioapp/widget/mytext.dart';
import '../widget/myimage.dart';

class NoData extends StatelessWidget {
  final String text;
  const NoData({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: transparent,
        borderRadius: BorderRadius.circular(12),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyImage(
            height: 80,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.contain,
            imagePath: "ic_mic.png",
          ),
          const SizedBox(height: 5),
          const MyText(
              color: black,
              text: "whoops",
              multilanguage: true,
              textalign: TextAlign.center,
              fontsize: 22,
              inter: 1,
              maxline: 1,
              fontwaight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
              fontstyle: FontStyle.normal),
          const SizedBox(height: 5),
           MyText(
              color: gray,
              text: text,
              textalign: TextAlign.center,
              fontsize: 14,
              multilanguage: true,
              inter: 1,
              maxline: 1,
              fontwaight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontstyle: FontStyle.normal),
        ],
      ),
    );
  }
}
