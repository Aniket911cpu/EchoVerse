import 'package:flutter/material.dart';
import 'package:radioapp/model/allsongmodel.dart';
import 'package:radioapp/webservice/apiservices.dart';

class AllRadioViewAllProvider extends ChangeNotifier {
  AllsongModel allSongsModel = AllsongModel();
  bool loading = false;

  getAllSong(String pageno) async {
    loading = true;
    allSongsModel = await ApiService().allSong(pageno);
    loading = false;
    notifyListeners();
  }
}
