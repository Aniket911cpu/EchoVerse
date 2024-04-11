// To parse this JSON data, do
//
//     final addfavouriteModel = addfavouriteModelFromJson(jsonString);

import 'dart:convert';

AddfavouriteModel addfavouriteModelFromJson(String str) =>
    AddfavouriteModel.fromJson(json.decode(str));

String addfavouriteModelToJson(AddfavouriteModel data) =>
    json.encode(data.toJson());

class AddfavouriteModel {
  AddfavouriteModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<dynamic>? result;

  factory AddfavouriteModel.fromJson(Map<String, dynamic> json) =>
      AddfavouriteModel(
        status: json["status"],
        message: json["message"],
        result: List<dynamic>.from(json["result"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x)),
      };
}
