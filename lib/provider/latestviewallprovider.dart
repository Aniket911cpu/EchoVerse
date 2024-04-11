import 'package:flutter/material.dart';
import 'package:echoverse/model/latestsongmodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

class LatestRadioViewAllProvider extends ChangeNotifier {
  LatestsongModel latestsongModel = LatestsongModel();
  bool loading = false;

  getLatestSong(String pageno) async {
    loading = true;
    latestsongModel = await ApiService().latestSong(pageno);
    loading = false;
    notifyListeners();
  }
}
