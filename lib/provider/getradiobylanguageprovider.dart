import 'package:flutter/material.dart';
import 'package:echoverse/model/getradiobylanguagemodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

class GetRadiobylanguageProvider extends ChangeNotifier {
  GetradiobylanguageModel getradiobylanguageModel = GetradiobylanguageModel();
  bool loading = false;

  getRadiobylanguage(String userid, String languageid, String pageno) async {
    loading = true;
    getradiobylanguageModel =
        await ApiService().radiobylanguage(userid, languageid, pageno);
    loading = false;
    notifyListeners();
  }
}
