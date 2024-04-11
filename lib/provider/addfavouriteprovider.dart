import 'package:flutter/material.dart';
import 'package:radioapp/model/addfavouritemodel.dart';
import 'package:radioapp/webservice/apiservices.dart';

class AddFavouriteProvider extends ChangeNotifier {
  AddfavouriteModel addfavouriteModel = AddfavouriteModel();
  bool loading = false;

  getAddFavourite(String userid, String songid) async {
    loading = true;
    addfavouriteModel = await ApiService().addfavourite(userid, songid);
    loading = false;
    notifyListeners();
  }
}
