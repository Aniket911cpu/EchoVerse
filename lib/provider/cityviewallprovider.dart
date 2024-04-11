import 'package:flutter/material.dart';
import 'package:echoverse/model/citymodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

class CityViewAllProvider extends ChangeNotifier {
  CityModel cityModel = CityModel();
  bool loading = false;

  getCity(int pageno) async {
    loading = true;
    cityModel = await ApiService().city(pageno);
    loading = false;
    notifyListeners();
  }
}
