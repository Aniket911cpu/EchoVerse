import 'package:flutter/material.dart';
import 'package:radioapp/model/profilemodel.dart';
import 'package:radioapp/webservice/apiservices.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel profileModel = ProfileModel();
  bool loading = false;

  getProfile(String userid) async {
    loading = true;
    profileModel = await ApiService().profile(userid);
    loading = false;
    notifyListeners();
  }
}
