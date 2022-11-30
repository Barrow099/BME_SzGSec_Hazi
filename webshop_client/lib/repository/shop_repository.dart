import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webshop_client/api/system/caff_picker.dart';
import 'package:webshop_client/api/system/notification_service.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/model/shop_model.dart';

import '../api/api.dart';

class ShopRepository {
  final AppRestApi appRestApi;

  ShopModel? _shopModel;

  ShopRepository(this.appRestApi);

  Future<ShopModel> refreshShopModel() async {
    final caffList = await appRestApi.getCaffList();
    _shopModel = ShopModel(caffList);
    return _shopModel!;
  }

  Future<CAFFData> getFullCaff(int caffId) {
    return appRestApi.getCaff(caffId);
  }

  Future addReview(int caffId, String content, int rating) async {
    await Future.delayed(const Duration(milliseconds: 200));
    await appRestApi.addReviewToCaff(caffId, content, rating);
  }

  deleteReview(int reviewId) async {
    await appRestApi.deleteReview(reviewId);
  }

  editReview(int reviewId, String content, int rating) async {
    await appRestApi.editReview(reviewId, content, rating);
  }

  downloadCaffs(List<CAFFData> inCartCaffs, Function(double) downloadProgressCallback) async {
    final status = await Permission.storage.request();
    if(!status.isGranted) {
      return Future.error("No storage permission");
    }

    final saveDirectory = await CaffPicker.pickSaveDirectory();
    if(saveDirectory == null) {
      return Future.error("Save directory not selected");
    }

    await appRestApi.downloadCaffs(inCartCaffs, saveDirectory, (double progress, CAFFData caffData) async {
      downloadProgressCallback(progress);
      final inProgressDownload = progress < 1;
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
          'dwnload',
          'Download notification',
          channelDescription: 'Download progress notfication',
          importance: Importance.defaultImportance,
          priority: Priority.high,
          ticker: 'ticker',
          showProgress: inProgressDownload,
          progress: (progress * 100).toInt(),
          maxProgress: 100
      );
      NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
      await NotificationService.localNotifications.show(
        caffData.id,
        inProgressDownload ? "Downloading caff..." : "Downloaded caff!",
        "caff_${caffData.id}.caff",
        notificationDetails,
      );
    });
  }

  Future uploadCaff(File selectedCaff, int price) async {
    await appRestApi.uploadCaff(selectedCaff, price);
  }

}