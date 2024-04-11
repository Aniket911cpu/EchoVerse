import 'package:flutter/material.dart';
import 'package:radioapp/model/getradiobycitymodel.dart';
import 'package:radioapp/webservice/apiservices.dart';

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
