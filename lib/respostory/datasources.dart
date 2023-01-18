import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:mx_exchange/common/network/client.dart';
import 'package:mx_exchange/models/authentication.dart';
import 'package:mx_exchange/models/category.dart';
import 'package:mx_exchange/models/question.dart';
import 'package:mx_exchange/models/relate.dart';
import 'package:platform_device_id/platform_device_id.dart';

class DataSources {
  final AppClient appClient;

  DataSources(this.appClient);

  Future<Authentication> login() async {
    final deviceId = await PlatformDeviceId.getDeviceId ?? "Unknow";
    final body = {"username": deviceId};
    final response = await appClient.post("login", body: body, isNoData: true);
    return Authentication.fromJson(response);
  }

  Future<List<CategoryItem>> getCategory(int page) async {
    final params = {'limit': 100, 'page': page};
    final response = await appClient.get("categories", queryParams: params);
    final json = response.data;
    final jsonArray = json["data"];
    final items =
        List<CategoryItem>.from(jsonArray.map((e) => CategoryItem.fromJson(e)));
    return items;
  }

  Future<List<Question>> getQuestionsWith({required List<int> ids}) async {
    final body = {"category_id": ids};
    final response = await appClient.post("question", body: body);
    var data = <Question>[];
    if (response.data != null) {
      final jsonArray = response.data as List<dynamic>;
      for (var v in jsonArray) {
        data!.add(Question.fromJson(v));
      }
    }
    return data;
  }

  Future<Relate> getRelateCategories({required List<int> ids}) async {
    final body = {"category_id": ids};
    final response = await appClient.post("categories/summary", body: body);
    return Relate.fromJson(response.data);
  }

  Future<bool> answer(int categoryId, int questionId, int answerId) async {
    final Map<String, dynamic> body = {
      "category_id": categoryId,
      "question_id": questionId,
      "answer_id": answerId
    };
    final response = await appClient.post("user-answer", body: body);
    return response.success;
  }

  Future<bool> reset(int deckId) async {
    final Map<String, dynamic> body = {
      "category_id": deckId,
    };
    final response = await appClient.post("categories/reset-deck", body: body);
    return response.success;
  }

  Future<bool> skip(int categoryId, int questionId) async {
    final Map<String, dynamic> body = {
      "category_id": categoryId,
      "question_id": questionId,
    };
    final response = await appClient.post("skip-answer", body: body);
    return response.data as bool;
  }

  Future<bool> watchVideo(int categoryId) async {
    final Map<String, dynamic> body = {
      "category_id":categoryId
    };
    final response = await appClient.post("categories/watch-video", body: body);
    return response.success;
  }

  Future<bool> inAppPurchaseIOS(PurchasedItem item) async {
    final Map<String, dynamic> body = {
      "transaction_id" : item.transactionId ?? "",
      "is_trial": true,
      "receipt_data" : item.transactionReceipt ?? ""
    };
    try {
      final response = await appClient.post("iap-items/ios", body: body);
      return response.data as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> inAppPurchaseAndroid(PurchasedItem item) async {

    final Map<String, dynamic> body = {
      "order_id":item.transactionId ?? "",
      "product_id":item.productId,
      "is_trial":true,
      "token":item.purchaseToken ?? ""
    };

    try {
      final response = await appClient.post("iap-items/android", body: body);
      return response.data as bool;
    } catch (e) {
      rethrow;
    }
  }

}
