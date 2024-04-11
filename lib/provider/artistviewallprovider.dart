import 'package:flutter/material.dart';
import 'package:echoverse/model/artistmodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

class ArtistViewAllProvider extends ChangeNotifier {
  ArtistModel artistModel = ArtistModel();
  bool loading = false;

  getArtist(String pageno) async {
    loading = true;
    artistModel = await ApiService().artist(pageno);
    loading = false;
    notifyListeners();
  }
}
