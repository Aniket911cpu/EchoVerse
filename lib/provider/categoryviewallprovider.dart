import 'package:flutter/material.dart';
import 'package:radioapp/model/categorymodel.dart';
import 'package:radioapp/webservice/apiservices.dart';

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
