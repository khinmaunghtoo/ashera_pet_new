// 自訂義異常
import 'dart:convert';

import 'package:dio/dio.dart';

import 'model/error_model.dart';


class AppException implements Exception {
  final String _message;
  final int _code;

  AppException(
      this._code,
      this._message,
      );

  @override
  String toString() {
    return _message;
  }

  String getMessage() {
    return _message;
  }

  factory AppException.create(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        {
          return BadRequestException(-1, "請求取消");
        }
      case DioExceptionType.connectionTimeout:
        {
          return BadRequestException(-1, "連接超時");
        }
      case DioExceptionType.sendTimeout:
        {
          return BadRequestException(-1, "請求超時");
        }
      case DioExceptionType.receiveTimeout:
        {
          return BadRequestException(-1, "響應超時");
        }
      case DioExceptionType.badResponse:
        {
          try {
            int? errCode = error.response!.statusCode;
            print('Error: ${error.requestOptions.path}');
            print('Error: ${error.message}');
            print('Error: ${error.response!.statusCode}');
            print('Error: ${error.response!.statusMessage}');
            ErrorModel errorModel = ErrorModel.fromJson(json.decode(json.encode(error.response!.data)));
            String? errMsg = errorModel.message;
            //return AppException(errCode!, errMsg!);
            switch (errCode) {
              case 400:
                {
                  return BadRequestException(errCode!, "$errMsg");
                }
              case 401:
                {
                  return BadRequestException(errCode!, "$errMsg");
                }
              case 403:
                {
                  return UnauthorisedException(errCode!, "$errMsg");
                }
              case 404:
                {
                  return UnauthorisedException(errCode!, "$errMsg");
                }
              case 405:
                {
                  return UnauthorisedException(errCode!, "$errMsg");
                }
              case 500:
                {
                  return UnauthorisedException(errCode!, "$errMsg");
                }
              case 502:
                {
                  return UnauthorisedException(errCode!, "$errMsg");
                }
              case 503:
                {
                  return UnauthorisedException(errCode!, "$errMsg");
                }
              case 505:
                {
                  return UnauthorisedException(errCode!, "$errMsg");
                }
              default:
                {
                  return AppException(errCode!, errMsg!);
                }
            }
          } on Exception catch (_) {
            return AppException(-1, "未知錯誤");
          }
        }
      default:
        {
          return AppException(-1, '');
        }
    }
  }
}

/// 請求錯誤
class BadRequestException extends AppException {
  BadRequestException(super.code, super.message);
}

/// 未認證異常
class UnauthorisedException extends AppException {
  UnauthorisedException(super.code, super.message);
}