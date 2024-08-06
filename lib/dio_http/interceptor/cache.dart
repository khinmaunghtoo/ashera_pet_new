import 'dart:collection';

import 'package:dio/dio.dart';

import '../utils/shared_preference.dart';

const int CACHE_MAXAGE = 86400000;
const int CACHE_MAXCOUNT = 1000;
const bool CACHE_ENABLE = false;

class CacheObject {
  CacheObject(this.response)
      : timeStamp = DateTime.now().millisecondsSinceEpoch;
  Response response;
  int timeStamp;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}

class NetCacheInterceptor extends Interceptor {
  // 為確保迭代器順序和對象插入時間一致順序一致，我們使用LinkedHashMap
  // ignore: prefer_collection_literals
  var cache = LinkedHashMap<String, CacheObject>();

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler requestCb,
      ) async {
    if (!CACHE_ENABLE) {
      return super.onRequest(options, requestCb);
    }

    // refresh標記是否是刷新緩存
    bool refresh = options.extra["refresh"] == true;

    // 是否磁盤緩存
    bool cacheDisk = options.extra["cacheDisk"] == true;

    // 如果刷新，先刪除相關緩存
    if (refresh) {
      // 刪除uri相同的內存緩存
      delete(options.uri.toString());

      // 刪除磁盤緩存
      if (cacheDisk) {
        await DioSharedPreferenceUtil().remove(options.uri.toString());
      }

      return;
    }

    // get 請求，開啟緩存
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == 'get') {
      String key = options.extra["cacheKey"] ?? options.uri.toString();

      // 策略 1 內存緩存優先，2 然後才是磁盤緩存

      // 1 內存緩存
      var ob = cache[key];
      if (ob != null) {
        //若緩存未過期，則返回緩存內容
        if ((DateTime.now().millisecondsSinceEpoch - ob.timeStamp) / 1000 <
            CACHE_MAXAGE) {
          return;
        } else {
          //若已過期則刪除緩存，繼續向服務器請求
          cache.remove(key);
        }
      }

      // 2 磁盤緩存
      if (cacheDisk) {
        var cacheData = DioSharedPreferenceUtil().getJSON(key);
        if (cacheData != null) {
          return;
        }
      }
    }
    return super.onRequest(options, requestCb);
  }

  @override
  void onResponse(
      Response response, ResponseInterceptorHandler responseCb) async {
    // 如果啟用緩存，將返回結果保存到緩存
    if (CACHE_ENABLE) {
      await _saveCache(response);
    }
    return super.onResponse(response, responseCb);
  }

  Future<void> _saveCache(Response object) async {
    RequestOptions options = object.requestOptions;

    // 只緩存 get 的請求
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == "get") {
      // 策略：內存、磁盤都寫緩存

      // 緩存key
      String key = options.extra["cacheKey"] ?? options.uri.toString();

      // 磁盤緩存
      if (options.extra["cacheDisk"] == true) {
        await DioSharedPreferenceUtil().setJSON(key, object.data);
      }

      // 内存缓存
      // 如果緩存數量超過最大數量限制，則先移除最早的一條記錄
      if (cache.length == CACHE_MAXCOUNT) {
        cache.remove(cache[cache.keys.first]);
      }

      cache[key] = CacheObject(object);
    }
  }

  void delete(String key) {
    cache.remove(key);
  }
}