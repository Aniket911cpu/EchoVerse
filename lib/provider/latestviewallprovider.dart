import 'package:flutter/material.dart';
import 'package:radioapp/model/latestsongmodel.dart';
import 'package:radioapp/webservice/apiservices.dart';

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
