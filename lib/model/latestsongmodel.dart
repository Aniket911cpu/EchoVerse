// To parse this JSON data, do
//
//     final latestsongModel = latestsongModelFromJson(jsonString);

import 'dart:convert';

LatestsongModel latestsongModelFromJson(String str) =>
    LatestsongModel.fromJson(json.decode(str));

String latestsongModelToJson(LatestsongModel data) =>
    json.encode(data.toJson());

class LatestsongModel {
  LatestsongModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  String? currentPage;
  bool? morePage;

  factory LatestsongModel.fromJson(Map<String, dynamic> json) =>
      LatestsongModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        totalRows: json["total_rows"],
        totalPage: json["total_page"],
        currentPage: json["current_page"],
        morePage: json["more_page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
        "total_rows": totalRows,
        "total_page": totalPage,
        "current_page": currentPage,
        "more_page": morePage,
      };
}

class Result {
  Result({
    this.id,
    this.categoryId,
    this.languageId,
    this.artistId,
    this.cityId,
    this.name,
    this.image,
    this.songUrl,
    this.songUploadType,
    this.view,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.categoryName,
    this.languageName,
    this.artistName,
    this.cityName,
    this.isFavorite,
  });

  int? id;
  int? categoryId;
  int? languageId;
  int? artistId;
  int? cityId;
  String? name;
  String? image;
  String? songUrl;
  String? songUploadType;
  int? view;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? categoryName;
  String? languageName;
  String? artistName;
  String? cityName;
  int? isFavorite;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        artistId: json["artist_id"],
        cityId: json["city_id"],
        name: json["name"],
        image: json["image"],
        songUrl: json["song_url"],
        songUploadType: json["song_upload_type"],
        view: json["view"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        categoryName: json["category_name"],
        languageName: json["language_name"],
        artistName: json["artist_name"],
        cityName: json["city_name"],
        isFavorite: json["is_favorite"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "language_id": languageId,
        "artist_id": artistId,
        "city_id": cityId,
        "name": name,
        "image": image,
        "song_url": songUrl,
        "song_upload_type": songUploadType,
        "view": view,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "category_name": categoryName,
        "language_name": languageName,
        "artist_name": artistName,
        "city_name": cityName,
        "is_favorite": isFavorite,
      };
}
