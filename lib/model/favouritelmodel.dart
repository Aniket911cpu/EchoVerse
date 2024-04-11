// To parse this JSON data, do
//
//     final favouriteModel = favouriteModelFromJson(jsonString);

import 'dart:convert';

FavouriteModel favouriteModelFromJson(String str) =>
    FavouriteModel.fromJson(json.decode(str));

String favouriteModelToJson(FavouriteModel data) => json.encode(data.toJson());

class FavouriteModel {
  FavouriteModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory FavouriteModel.fromJson(Map<String, dynamic> json) => FavouriteModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
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
