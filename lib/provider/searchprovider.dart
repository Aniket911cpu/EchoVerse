import 'package:flutter/material.dart';
import 'package:echoverse/model/searchmodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

class SearchProvider extends ChangeNotifier {
  SearchModel searchModel = SearchModel();
  bool loading = false;

  getSearch(String userid, String songname) async {
    loading = true;
    searchModel = await ApiService().search(userid, songname);
    loading = false;
    notifyListeners();
  }

  clearProvider() {
    debugPrint("<================ clearProvider ================>");
    searchModel = SearchModel();
    notifyListeners();
  }
}
