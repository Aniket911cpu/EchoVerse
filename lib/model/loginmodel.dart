// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
    this.name,
    this.mobile,
    this.email,
    this.password,
    this.image,
    this.type,
    this.status,
    this.coinBalance,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? mobile;
  String? email;
  String? password;
  String? image;
  int? type;
  int? status;
  int? coinBalance;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        password: json["password"],
        image: json["image"],
        type: json["type"],
        status: json["status"],
        coinBalance: json["coin_balance"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "email": email,
        "password": password,
        "image": image,
        "type": type,
        "status": status,
        "coin_balance": coinBalance,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
