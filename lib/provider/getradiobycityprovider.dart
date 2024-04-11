import 'package:flutter/material.dart';
import 'package:echoverse/model/getradiobycitymodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

class GetRadiobyCityProvider extends ChangeNotifier {
  GetradiobycityModel getradiobycityModel = GetradiobycityModel();
  bool loading = false;

  getRadiobycity(
      String userid, String cityid, String languageid, String pageno) async {
    loading = true;
    getradiobycityModel =
        await ApiService().radiobycity(userid, cityid, languageid, pageno);
    loading = false;
    notifyListeners();
  }
}
