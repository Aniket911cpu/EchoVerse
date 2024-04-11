import 'package:flutter/material.dart';
import 'package:radioapp/model/notificationlistmodel.dart';
import 'package:radioapp/webservice/apiservices.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationModel notificationModel = NotificationModel();
  bool loading = false;

  getNotification(String userid) async {
    loading = true;
    notificationModel = await ApiService().notification(userid);
    loading = false;
    notifyListeners();
  }
}
