import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:echoverse/pages/home.dart';
import 'package:echoverse/pages/intro.dart';
import 'package:echoverse/provider/generalprovider.dart';
import 'package:echoverse/utils/sharedpref.dart';
import 'package:echoverse/widget/myimage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  SharedPref sharedpre = SharedPref();
  @override
  void initState() {
    super.initState();
    getApi();
  }

  getApi() async {
    final splashdata = Provider.of<GeneralProvider>(context, listen: false);
    await splashdata.getGeneralsetting();
  }

  @override
  Widget build(BuildContext context) {
    checkFirstSeen();
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: MyImage(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          imagePath: "ic_splashbg.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future checkFirstSeen() async {
    final splashdata = Provider.of<GeneralProvider>(context);

    if (!splashdata.loading) {
      for (var i = 0; i < splashdata.generalSettingModel.result!.length; i++) {
        sharedpre.save(
          splashdata.generalSettingModel.result?[i].key.toString() ?? "",
          splashdata.generalSettingModel.result?[i].value.toString() ?? "",
        );
      }

      String? seen = await sharedpre.read("seen") ?? "";
      debugPrint("boolian Main statement is : $seen");

      if (seen.toString() == "1") {
        debugPrint("Boolian statement if Condition : $seen");
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Home();
            },
          ),
        );
      } else {
        debugPrint("Boolian statement Else Condition : $seen");
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Intro();
            },
          ),
        );
      }
    }
  }
}
