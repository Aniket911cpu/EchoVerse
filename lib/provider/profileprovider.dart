import 'package:flutter/material.dart';
import 'package:echoverse/model/profilemodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

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
