import 'package:flutter/material.dart';
import 'package:radioapp/model/generalsettingmodel.dart';
import 'package:radioapp/model/loginmodel.dart';
import 'package:radioapp/webservice/apiservices.dart';

class GeneralProvider extends ChangeNotifier {
  GeneralsettingModel generalSettingModel = GeneralsettingModel();
  LoginModel loginModel = LoginModel();
  bool loading = false;

  getGeneralsetting() async {
    loading = true;
    generalSettingModel = await ApiService().generalSetting();
    loading = false;
    notifyListeners();
  }

  getLogin(String type, String mobile, String email) async {
    loading = true;
    loginModel = await ApiService().login(type, mobile, email);
    loading = false;
    notifyListeners();
  }
}
