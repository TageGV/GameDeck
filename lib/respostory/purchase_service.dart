import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:mx_exchange/common/exceptions/network_exceptions.dart';
import 'package:mx_exchange/common/exceptions/server_exceptions.dart';
import 'package:mx_exchange/respostory/datasources.dart';

class PaymentService {
  PaymentService._internal();

  static final PaymentService instance = PaymentService._internal();

  DataSources? dataSources;

  /// To listen the status of connection between app and the billing server
  StreamSubscription<ConnectionResult>? _connectionSubscription;

  /// If status is not error then app will be notied by this stream
  StreamSubscription<PurchasedItem?>? _purchaseUpdatedSubscription;

  /// To listen the errors of the purchase
  StreamSubscription<PurchaseResult?>? _purchaseErrorSubscription;

  // TODO: - Add Products Id
  /// List of product ids you want to fetch
  final List<String> _productIds = ['user_premium'];

  /// All available products will be store in this list
  List<IAPItem>? _products;

  /// All past purchases will be store in this list
  List<PurchasedItem>? _pastPurchases;

  /// view of the app will subscribe to this to get notified
  /// when premium status of the user changes
  final ObserverList<Function> _proStatusChangedListeners = ObserverList();

  /// view of the app will subscribe to this to get errors of the purchase
  final ObserverList<Function(String?)> _errorListeners =
      ObserverList<Function(String?)>();

  /// logged in user's premium status
  bool _isProUser = false;

  bool get isProUsers => _isProUser;

  addDataSources(DataSources dataSources) {
    this.dataSources = dataSources;
  }

  /// view can subscribe to _proStatusChangedListeners using this method
  addToProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.add(callback);
  }

  /// view can cancel to _proStatusChangedListeners using this method
  removeFromProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.remove(callback);
  }

  /// view can subscribe to _errorListeners using this method
  addToErrorListeners(Function(String?) callback) {
    _errorListeners.add(callback);
  }

  /// view can cancel to _errorListeners using this method
  removeFromErrorListeners(Function(String?) callback) {
    _errorListeners.remove(callback);
  }

  /// Call this method to notify all the subsctibers of _proStatusChangedListeners
  void _callProStatusChangedListeners() {
    for (var callback in _proStatusChangedListeners) {
      callback();
    }
  }

  /// Call this method to notify all the subsctibers of _errorListeners
  void _callErrorListeners(String? error) {
    for (var callback in _errorListeners) {
      callback(error);
    }
  }

  /// Call this method at the startup of you app to initialize connection
  /// with billing server and get all the necessary data
  void initConnection() async {
    await FlutterInappPurchase.instance.initialize();

    await FlutterInappPurchase.instance.initialize();

    _connectionSubscription = FlutterInappPurchase.connectionUpdated.listen((connected) {});

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen(_handlePurchaseUpdate);

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen(_handlePurchaseError);

    _getItems();

    // _getPastPurchases();
  }

  void _handlePurchaseError(PurchaseResult? purchaseError) {
    _callErrorListeners(purchaseError?.message);
  }

  /// Called when new updates arrives at ``purchaseUpdated`` stream
  void _handlePurchaseUpdate(PurchasedItem? productItem) async {
    if (Platform.isAndroid) {
      if(productItem != null) {
        await _handlePurchaseUpdateAndroid(productItem);
      } else {
      }
    } else {
      if (productItem != null) {
        await _handlePurchaseUpdateIOS(productItem);
      }
      else {
        print("Error not handle empty PurchasedItem");
      }
    }
  }

  Future<void> _handlePurchaseUpdateIOS(PurchasedItem purchasedItem) async {
    switch (purchasedItem.transactionStateIOS) {
      case TransactionState.deferred:
        break;
      case TransactionState.failed:
        _callErrorListeners("Transaction Failed");
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.purchased:
        await _verifyAndFinishTransaction(purchasedItem);
        break;
      case TransactionState.purchasing:
        break;
      case TransactionState.restored:
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      default:
    }
  }

  /// three purchase state https://developer.android.com/reference/com/android/billingclient/api/Purchase.PurchaseState
  /// 0 : UNSPECIFIED_STATE
  /// 1 : PURCHASED
  /// 2 : PENDING
  Future<void> _handlePurchaseUpdateAndroid(PurchasedItem purchasedItem) async {
    switch (purchasedItem.purchaseStateAndroid) {
      case PurchaseState.unspecified:
        if (purchasedItem.isAcknowledgedAndroid == false) {
          await _verifyAndFinishTransaction(purchasedItem);
        }
        break;
      default:
        _callErrorListeners("Something went wrong");
    }
  }

  /// Call this method when status of purchase is success
  /// Call API of your back end to verify the reciept
  /// back end has to call billing server's API to verify the purchase token
  _verifyAndFinishTransaction(PurchasedItem purchasedItem) async {
    bool isValid = false;
    try {
      // Call API
      isValid = await _verifyPurchase(purchasedItem);
    } on ServerException {
      _callErrorListeners(null);
      return;
    } on NetworkException {
      _callErrorListeners(null);
      return;
    } on Exception {
      _callErrorListeners("Subscriptions Error!");
      return;
    }

    if (isValid) {
      FlutterInappPurchase.instance.finishTransaction(purchasedItem);
      _isProUser = true;
      // save in sharedPreference here
      _callProStatusChangedListeners();
    } else {
      _callErrorListeners("Varification failed");
    }
  }

  Future<bool> _verifyPurchase(PurchasedItem item) async {
    if(dataSources != null) {
      try {
        if(Platform.isIOS) {
          final result = await dataSources!.inAppPurchaseIOS(item);
          return result;
        } else {
          final result = await dataSources!.inAppPurchaseAndroid(item);
          return result ;
        }
      } catch (e) {
        rethrow;
      }
    }else {
      return false;
    }
  }

  Future<List<IAPItem>> get products async {
    if (_products == null) {
      await _getItems();
    }
    return _products ?? [];
  }

  Future<void> _getItems() async {
    List<IAPItem> items = await FlutterInappPurchase.instance.getSubscriptions(_productIds);
    _products = [];
    for (var item in items) {
      _products?.add(item);
    }
  }

  void _getPastPurchases() async {
    // remove this if you want to restore past purchases in iOS
    if (Platform.isIOS) {
      return;
    }
    List<PurchasedItem> purchasedItems = await FlutterInappPurchase.instance.getAvailablePurchases() ?? [];

    for (var purchasedItem in purchasedItems) {
      bool isValid = false;

      if (Platform.isAndroid) {
        Map map = json.decode(purchasedItem.transactionReceipt ?? "");
        // if your app missed finishTransaction due to network or crash issue
        // finish transactins
        if (!map['acknowledged']) {
          isValid = await _verifyPurchase(purchasedItem);
          if (isValid) {
            FlutterInappPurchase.instance.finishTransaction(purchasedItem);
            _isProUser = true;
            _callProStatusChangedListeners();
          }
        } else {
          _isProUser = true;
          _callProStatusChangedListeners();
        }
      }
    }

    _pastPurchases = [];
    _pastPurchases?.addAll(purchasedItems);
  }

  Future<void> buyProduct(IAPItem item) async {
    try {
      final result = await FlutterInappPurchase.instance.requestSubscription(item.productId!);
    } catch (error) {
      rethrow;
    }
  }

}

class NoInternetException implements Exception {
  final String? message;
  NoInternetException({this.message});
}
