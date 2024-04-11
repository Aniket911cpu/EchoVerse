import 'package:flutter/material.dart';
import 'package:radioapp/model/citymodel.dart';
import 'package:radioapp/webservice/apiservices.dart';

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
