import 'package:flutter/material.dart';
import 'package:echoverse/model/languagemodel.dart';
import 'package:echoverse/webservice/apiservices.dart';

class LanguageViewAllProvider extends ChangeNotifier {
  LanguageModel languageModel = LanguageModel();
  bool loading = false;

  getLanguage(String pageno) async {
    loading = true;
    languageModel = await ApiService().language(pageno);
    loading = false;
    notifyListeners();
  }
}
