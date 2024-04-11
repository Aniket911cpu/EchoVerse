import 'package:flutter/material.dart';
import 'package:echoverse/model/favouritelmodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

class FavouriteProvider extends ChangeNotifier {
  FavouriteModel favouriteModel = FavouriteModel();
  bool loading = false;

  getFavourite(String userid, String pageno) async {
    loading = true;
    favouriteModel = await ApiService().favourite(userid, pageno);
    loading = false;
    notifyListeners();
  }
}
