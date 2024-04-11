import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:radioapp/model/addfavouritemodel.dart';
import 'package:radioapp/model/allsongmodel.dart';
import 'package:radioapp/model/artistmodel.dart';
import 'package:radioapp/model/citymodel.dart';
import 'package:radioapp/model/favouritelmodel.dart';
import 'package:radioapp/model/getradiobyartistmodel.dart';
import 'package:radioapp/model/getradiobycategorymodel.dart';
import 'package:radioapp/model/getradiobycitymodel.dart';
import 'package:radioapp/model/getradiobylanguagemodel.dart';
import 'package:radioapp/model/languagemodel.dart';
import 'package:radioapp/model/latestsongmodel.dart';
import 'package:radioapp/model/bannermodel.dart';
import 'package:radioapp/model/categorymodel.dart';
import 'package:radioapp/model/generalsettingmodel.dart';
import 'package:radioapp/model/loginmodel.dart';
import 'package:radioapp/model/notificationlistmodel.dart';
import 'package:radioapp/model/profilemodel.dart';
import 'package:radioapp/model/searchmodel.dart';
import 'package:radioapp/model/updateprofilemodel.dart';
import 'package:radioapp/utils/constant.dart';

class ApiService {
  String baseurl = Constant().baseurl;
  late Dio dio;

  ApiService() {
    dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.interceptors.add(dioLoggerInterceptor);
  }

  Future<GeneralsettingModel> generalSetting() async {
    GeneralsettingModel generalsettingModel;
    String generalsetting = 'general_setting';
    Response response = await dio.post('$baseurl$generalsetting');
    generalsettingModel = GeneralsettingModel.fromJson((response.data));
    return generalsettingModel;
  }

  Future<LoginModel> login(type, mobile, email) async {
    debugPrint("type=>$type");
    debugPrint("mobile=>$mobile");
    debugPrint("email=>$email");
    LoginModel loginModel;
    String login = "login";
    Response response = await dio.post('$baseurl$login',
        data: FormData.fromMap({
          'type': MultipartFile.fromString(type),
          'mobile': MultipartFile.fromString(mobile),
          'email': MultipartFile.fromString(email),
        }));

    loginModel = LoginModel.fromJson(response.data);
    return loginModel;
  }

  Future<LanguageModel> language(String pageno) async {
    LanguageModel languageModel;
    String language = 'get_language';
    Response response = await dio.post('$baseurl$language',
        data: FormData.fromMap({
          'page_no': MultipartFile.fromString(pageno),
        }));
    languageModel = LanguageModel.fromJson((response.data));
    return languageModel;
  }

  Future<CityModel> city(int pageno) async {
    CityModel cityModel;
    String city = 'get_city';
    Response response = await dio.post('$baseurl$city',
        data: FormData.fromMap({
          'page_no': MultipartFile.fromString(pageno.toString()),
        }));
    cityModel = CityModel.fromJson((response.data));
    return cityModel;
  }

  Future<BannerModel> banner() async {
    BannerModel bannerModel;
    String getbanner = 'get_banner';
    Response response = await dio.post('$baseurl$getbanner');
    bannerModel = BannerModel.fromJson((response.data));
    return bannerModel;
  }

  Future<CategoryModel> category(String pageno) async {
    CategoryModel categoryModel;
    String getcategory = 'get_category';
    Response response = await dio.post('$baseurl$getcategory',
        data: FormData.fromMap({
          'page_no': MultipartFile.fromString(pageno),
        }));
    categoryModel = CategoryModel.fromJson((response.data));
    return categoryModel;
  }

  Future<AllsongModel> allSong(String pageno) async {
    AllsongModel allsongModel;
    String allsong = 'all_song';
    Response response = await dio.post('$baseurl$allsong',
        data: FormData.fromMap({
          'page_no': MultipartFile.fromString(pageno),
        }));
    allsongModel = AllsongModel.fromJson((response.data));
    return allsongModel;
  }

  Future<LatestsongModel> latestSong(String pageno) async {
    LatestsongModel latestsongModel;
    String getLatestSong = 'get_latest_song';
    Response response = await dio.post('$baseurl$getLatestSong',
        data: FormData.fromMap({
          'page_no': MultipartFile.fromString(pageno),
        }));
    latestsongModel = LatestsongModel.fromJson((response.data));
    return latestsongModel;
  }

  Future<ArtistModel> artist(String pageno) async {
    ArtistModel artistModel;
    String artist = 'get_artist';
    Response response = await dio.post('$baseurl$artist',
        data: FormData.fromMap({
          'page_no': MultipartFile.fromString(pageno),
        }));
    artistModel = ArtistModel.fromJson((response.data));
    return artistModel;
  }

  Future<FavouriteModel> favourite(String userid, String pageno) async {
    FavouriteModel favouriteModel;
    String favourite = 'get_favorite_list';
    Response response = await dio.post('$baseurl$favourite',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'page_no': MultipartFile.fromString(pageno),
        }));
    favouriteModel = FavouriteModel.fromJson((response.data));
    return favouriteModel;
  }

  Future<ProfileModel> profile(String userid) async {
    ProfileModel profileModel;
    String profile = 'get_profile';
    Response response = await dio.post('$baseurl$profile',
        data: FormData.fromMap({
          'id': MultipartFile.fromString(userid),
        }));
    profileModel = ProfileModel.fromJson((response.data));
    return profileModel;
  }

  Future<NotificationModel> notification(String userid) async {
    NotificationModel notificationModel;
    String notification = 'notification_list';
    Response response = await dio.post('$baseurl$notification',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
        }));
    notificationModel = NotificationModel.fromJson((response.data));
    return notificationModel;
  }

  Future<UpdateprofileModel> updateprofile(String userid, String name,
      String email, String mobile, String password, File image) async {
    UpdateprofileModel updateprofileModel;
    String updateprofile = 'update_profile';
    Response response = await dio.post('$baseurl$updateprofile',
        data: FormData.fromMap({
          'id': MultipartFile.fromString(userid),
          'name': MultipartFile.fromString(name),
          'email': MultipartFile.fromString(email),
          'mobile': MultipartFile.fromString(mobile),
          'password': MultipartFile.fromString(password),
          if (image.path.isNotEmpty)
            "image": await MultipartFile.fromFile(image.path,
                filename: basename(image.path)),
        }));
    updateprofileModel = UpdateprofileModel.fromJson((response.data));
    return updateprofileModel;
  }

  Future<SearchModel> search(String userid, String songname) async {
    SearchModel searchModel;
    String search = 'search_radio_by_name';
    Response response = await dio.post('$baseurl$search',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'name': MultipartFile.fromString(songname),
        }));
    searchModel = SearchModel.fromJson((response.data));
    return searchModel;
  }

  Future<GetradiobyartistModel> radiobyartist(
      String artistid, String pageno) async {
    GetradiobyartistModel getradiobyartistModel;
    String getradiobyartist = 'get_radio_by_artist';
    Response response = await dio.post('$baseurl$getradiobyartist',
        data: FormData.fromMap({
          'artist_id': MultipartFile.fromString(artistid),
          'page_no': MultipartFile.fromString(pageno),
        }));
    getradiobyartistModel = GetradiobyartistModel.fromJson((response.data));
    return getradiobyartistModel;
  }

  Future<GetradiobycityModel> radiobycity(
      String userid, String cityid, String languageid, String pageno) async {
    GetradiobycityModel getradiobycityModel;
    String getradiobycity = 'get_radio_by_city';
    Response response = await dio.post('$baseurl$getradiobycity',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'city_id': MultipartFile.fromString(cityid),
          'language_id': MultipartFile.fromString(languageid),
          'page_no': MultipartFile.fromString(pageno),
        }));
    getradiobycityModel = GetradiobycityModel.fromJson((response.data));
    return getradiobycityModel;
  }

  Future<GetradiobycategoryModel> radiobycategory(String userid,
      String categoryid, String languageid, String pageno) async {
    GetradiobycategoryModel getradiobycategoryModel;
    String getradiobycategory = 'get_radio_by_category';
    Response response = await dio.post('$baseurl$getradiobycategory',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'category_id': MultipartFile.fromString(categoryid),
          'language_id': MultipartFile.fromString(languageid),
          'page_no': MultipartFile.fromString(pageno),
        }));
    getradiobycategoryModel = GetradiobycategoryModel.fromJson((response.data));
    return getradiobycategoryModel;
  }

  Future<GetradiobylanguageModel> radiobylanguage(
      String userid, String languageid, String pageno) async {
    GetradiobylanguageModel getradiobylanguageModel;
    String getradiobylanguage = 'get_radio_by_language';
    Response response = await dio.post('$baseurl$getradiobylanguage',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'language_id': MultipartFile.fromString(languageid),
          'page_no': MultipartFile.fromString(pageno),
        }));
    getradiobylanguageModel = GetradiobylanguageModel.fromJson((response.data));
    return getradiobylanguageModel;
  }

  Future<AddfavouriteModel> addfavourite(String userid, String songid) async {
    AddfavouriteModel addfavouriteModel;
    String addfavourite = 'add_remove_favorite';
    Response response = await dio.post('$baseurl$addfavourite',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'song_id': MultipartFile.fromString(songid),
        }));
    addfavouriteModel = AddfavouriteModel.fromJson((response.data));
    return addfavouriteModel;
  }
}
