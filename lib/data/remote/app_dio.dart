import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';

import 'dio_config.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultSendTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class AppDio with DioMixin implements Dio {
  DioConfig _dioConfig = DioConfig.of();

  AppDio._([BaseOptions? options]) {
    options ??= BaseOptions(
      baseUrl: _dioConfig.baseUrl,
      contentType: 'application/json',
      connectTimeout: _defaultConnectTimeout,
      sendTimeout: _defaultSendTimeout,
      receiveTimeout: _defaultReceiveTimeout,
    );

    this.options = options;

    // DioCacheManager
    final cacheOptions = CacheOptions(
      // A default store is required for interceptor.
      store: MemCacheStore(),
      // Optional. Returns a cached response on error but for statuses 401 & 403.
      hitCacheOnErrorExcept: [401, 403],
      // Optional. Overrides any HTTP directive to delete entry past this duration.
      maxStale: const Duration(days: 7),
    );
    interceptors.add(DioCacheInterceptor(options: cacheOptions));
    // Cookie管理
    interceptors.add(CookieManager(
        PersistCookieJar(storage: FileStorage(_dioConfig.cookiesPath))));

    if (kDebugMode) {
      interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
          request: false,
          requestBody: true));
    }
    if (_dioConfig.interceptors?.isNotEmpty ?? false) {
      interceptors.addAll(interceptors);
    }
    httpClientAdapter = DefaultHttpClientAdapter();
  }

  setProxy(String proxy) {
    (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      // config the http client
      client.findProxy = (uri) {
        // proxy all request to localhost:8888
        return "PROXY $proxy";
      };
      // you can also create a HttpClient to dio
      // return HttpClient();
    };
  }

  static AppDio getInstance() => AppDio._();
}
