import 'package:flutter/material.dart';
import 'package:echoverse/model/allsongmodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

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
