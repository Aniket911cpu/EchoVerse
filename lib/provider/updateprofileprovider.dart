import 'dart:io';
import 'package:flutter/material.dart';
import 'package:radioapp/model/updateprofilemodel.dart';
import 'package:radioapp/webservice/apiservices.dart';

class UpdateProfileProvider extends ChangeNotifier {
  UpdateprofileModel updateprofileModel = UpdateprofileModel();
  bool loading = false;

  getUpdateProfile(String userid, String name, String email, String mobile,
      String password, File image) async {
    loading = true;
    updateprofileModel = await ApiService()
        .updateprofile(userid, name, email, mobile, password, image);
    loading = false;
    notifyListeners();
  }
}
