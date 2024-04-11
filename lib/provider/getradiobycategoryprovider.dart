import 'package:flutter/material.dart';
import 'package:echoverse/model/getradiobycategorymodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

class GetRadiobyCategoryProvider extends ChangeNotifier {
  GetradiobycategoryModel getradiobycategoryModel = GetradiobycategoryModel();
  bool loading = false;

  getRadiobycategory(String userid, String categoryid, String languageid,
      String pageno) async {
    loading = true;
    getradiobycategoryModel = await ApiService()
        .radiobycategory(userid, categoryid, languageid, pageno);
    loading = false;
    notifyListeners();
  }
}
