import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'interceptor/cache.dart';
import 'interceptor/error.dart';
import 'interceptor/request.dart';
import 'interceptor/retry.dart';


class Http {
  static final Http _instance = Http._internal();
  factory Http() => _instance;

  static late final Dio dio;
  final CancelToken _cancelToken = CancelToken();

  Http._internal() {
    // BaseOptions、Options、RequestOptions 都可以配置參數，優先級別依次遞增，且可以根據優先級別覆蓋參數
    BaseOptions options = BaseOptions();

    dio = Dio(options);

    // 添加攔截器
    dio.interceptors.add(RequestInterceptor());
    // 添加error攔截器
    dio.interceptors.add(ErrorInterceptor());
    // 添加cache攔截器
    dio.interceptors.add(NetCacheInterceptor());
    // 添加retry攔截器
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetry: DioConnectivityRequestRetry(
          dio: dio,
          connectivity: Connectivity(),
        ),
      ),
    );
  }
  ///初始化公共屬性
  ///
  /// [baseUrl] 地址前綴
  /// [connectTimeout] 連接超時趕時間
  /// [receiveTimeout] 接收超時趕時間
  /// [interceptors] 基礎攔截器
  void init({
    String? baseUrl,
    Duration connectTimeout = const Duration(milliseconds: 30000),
    Duration receiveTimeout = const Duration(milliseconds: 30000),
    Map<String, String>? headers,
    List<Interceptor>? interceptors,
  }) {
    dio.options = dio.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: headers ?? const {},
    );
    if (interceptors != null && interceptors.isNotEmpty) {
      dio.interceptors.addAll(interceptors);
    }
  }

  // 關閉dio
  void cancelRequests({required CancelToken token}) {
    _cancelToken.cancel("cancelled");
  }

  // 添加認證
  // 讀取本地配置
  Map<String, dynamic>? getAuthorizationHeader() {
    Map<String, dynamic>? headers;
    // 从getx或者sputils中获取
    // String accessToken = Global.accessToken;
    // String accessToken = "";
    // if (accessToken != null) {
    //   headers = {
    //     'Authorization': 'Bearer $accessToken',
    //   };
    // }
    return headers;
  }

  Future get(
      String path, {
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
        bool refresh = false,
        bool noCache = !CACHE_ENABLE,
        String? cacheKey,
        bool cacheDisk = false,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.copyWith(
      extra: {
        "refresh": refresh,
        "noCache": noCache,
        "cacheKey": cacheKey,
        "cacheDisk": cacheDisk,
      },
    );
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions = requestOptions.copyWith(headers: authorization);
    }
    Response response;
    response = await dio.get(
      path,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken ?? _cancelToken,
    );

    return response.data;
  }

  Future post(
      String path, {
        Map<String, dynamic>? params,
        data,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    Options requestOptions = options ?? Options();
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions = requestOptions.copyWith(headers: authorization);
    }
    var response = await dio.post(
      path,
      data: data,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response.data;
  }

  Future put(
      String path, {
        data,
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions = requestOptions.copyWith(headers: authorization);
    }
    var response = await dio.put(
      path,
      data: data,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response.data;
  }

  Future patch(
      String path, {
        data,
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    Options requestOptions = options ?? Options();
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions = requestOptions.copyWith(headers: authorization);
    }
    var response = await dio.patch(
      path,
      data: data,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response.data;
  }

  Future delete(
      String path, {
        data,
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions = requestOptions.copyWith(headers: authorization);
    }
    var response = await dio.delete(
      path,
      data: data,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response.data;
  }

  Future upload(
      String path, {
        Map<String, dynamic>? params,
        data,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    Options requestOptions = options ?? Options();
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions = requestOptions.copyWith(headers: authorization);
    }
    var response = await dio.post(
      path,
      data: data,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response.data;
  }
}