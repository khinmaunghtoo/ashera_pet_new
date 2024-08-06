import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../app_exceptions.dart';

class MyDioSocketException extends SocketException {
  @override
  late String message;

  MyDioSocketException(
      message, {
        osError,
        address,
        port,
      }) : super(
    message,
    osError: osError,
    address: address,
    port: port,
  );
}

/// 錯誤處理攔截器
class ErrorInterceptor extends Interceptor {
  // 是否有網
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler errCb) async {
    // 自定義一個socket實例，因為dio原生的實例，message屬於是只讀的
    if (err.error is SocketException) {
      /*err.error = MyDioSocketException(
        err.message,
        osError: err.error?.osError,
        address: err.error?.address,
        port: err.error?.port,
      );*/
      err = err.copyWith(
          error: MyDioSocketException(
            err.message,
          )
      );
    }
    if (err.type == DioExceptionType.unknown) {
      bool isConnectNetWork = await isConnected();
      if (!isConnectNetWork && err.error is MyDioSocketException) {
        //err.error.message = "當前網絡不可用，請檢查您的網絡";
        err = err.copyWith(
            error: MyDioSocketException(
              "當前網絡不可用，請檢查您的網絡",
            )
        );
      }
    }
    // error統一處理
    AppException appException = AppException.create(err);
    // 錯誤提示
    debugPrint('DioError===: ${err.requestOptions.path} \n ${err.message} \n ${appException.toString()}');
    //err.error = appException;
    err = err.copyWith(
        error: appException,
        message: appException.getMessage()
    );
    return super.onError(err, errCb);
  }
}