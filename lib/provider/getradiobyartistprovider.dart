import 'package:flutter/material.dart';
import 'package:echoverse/model/getradiobyartistmodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

class GetRadiobyArtistProvider extends ChangeNotifier {
  GetradiobyartistModel getradiobyartistModel = GetradiobyartistModel();
  bool loading = false;

  getRadiobyArtist(String artistid, String pageno) async {
    loading = true;
    getradiobyartistModel = await ApiService().radiobyartist(artistid, pageno);
    loading = false;
    notifyListeners();
  }
}
