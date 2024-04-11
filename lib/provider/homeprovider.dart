import 'package:flutter/material.dart';
import 'package:echoverse/model/allsongmodel.dart';
import 'package:echoverse/model/artistmodel.dart';
import 'package:echoverse/model/citymodel.dart';
import 'package:echoverse/model/favouritelmodel.dart';
import 'package:echoverse/model/languagemodel.dart';
import 'package:echoverse/model/latestsongmodel.dart';
import 'package:echoverse/model/bannermodel.dart';
import 'package:echoverse/model/categorymodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

class HomeProvider extends ChangeNotifier {
  bool loading = false;
  BannerModel bannerModel = BannerModel();
  CategoryModel categoryModel = CategoryModel();
  LanguageModel languageModel = LanguageModel();
  CityModel cityModel = CityModel();
  AllsongModel allSongsModel = AllsongModel();
  LatestsongModel latestsongModel = LatestsongModel();
  ArtistModel artistModel = ArtistModel();
  FavouriteModel favouriteModel = FavouriteModel();

  String uid = "";

  getBanner() async {
    loading = true;
    bannerModel = await ApiService().banner();
    loading = false;
    notifyListeners();
  }

  getCategory(String pageno) async {
    loading = true;
    categoryModel = await ApiService().category(pageno);
    loading = false;
    notifyListeners();
  }

  getAllSong(String pageno) async {
    loading = true;
    allSongsModel = await ApiService().allSong(pageno);
    loading = false;
    notifyListeners();
  }

  getLanguage(String pageno) async {
    loading = true;
    languageModel = await ApiService().language(pageno);
    loading = false;
    notifyListeners();
  }

  getCity(int pageno) async {
    loading = true;
    cityModel = await ApiService().city(pageno);
    loading = false;
    notifyListeners();
  }

  getLatestSong(String pageno) async {
    loading = true;
    latestsongModel = await ApiService().latestSong(pageno);
    loading = false;
    notifyListeners();
  }

  getFavourite(String userid, String pageno) async {
    loading = true;
    favouriteModel = await ApiService().favourite(userid, pageno);
    loading = false;
    notifyListeners();
  }

  getArtist(String pageno) async {
    loading = true;
    artistModel = await ApiService().artist(pageno);
    loading = false;
    notifyListeners();
  }

  valueUpdate(String id) {
    uid = id;
    notifyListeners();
  }
}
