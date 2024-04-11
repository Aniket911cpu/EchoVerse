import 'package:flutter/material.dart';
import 'package:echoverse/model/categorymodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

class CategoryViewAllProvider extends ChangeNotifier {
  CategoryModel categoryModel = CategoryModel();
  bool loading = false;

  getCategory(String pageno) async {
    loading = true;
    categoryModel = await ApiService().category(pageno);
    loading = false;
    notifyListeners();
  }
}
