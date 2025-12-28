import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:smart_incident/feature/common/constants/api_urls.dart";
import "package:smart_incident/feature/common/enum/request_types.dart";
import "package:smart_incident/feature/common/widgets/custom_toast.dart";
import "package:smart_incident/main.dart";
import "package:smart_incident/utils/app_routing/app_routes.dart";

final class ApiClient {
  static final instance = ApiClient._();

  late final Dio _dioClient;

  final Duration timeOutDuration = const Duration(seconds: 180);
  static String token = "";

  ApiClient._() {
    _dioClient = Dio(BaseOptions(baseUrl: ApiUrls.baseUrl));
    // getAccessToken();

    if (!kReleaseMode) {
      _dioClient.interceptors.add(
        LogInterceptor(
          responseBody: true,
          requestHeader: true,
          responseHeader: true,
          requestBody: true,
          error: true,
          request: true,
        ),
      );
    }
    _dioClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          bool isConnected =
              await InternetConnectionChecker.instance.hasConnection;
          if (!isConnected) {
            final context = MyApp.navigatorKey.currentContext;
            if (context != null) {
              CustomToast.show(
                context,
                message: "Please Check Your Internet Connection",
                toastEnum: ToastEnum.information,
              );
            }

            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                message: "No internet connection",
              ),
            );
          } else {
            handler.next(options);
          }
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) async {
          if (error.type == DioExceptionType.cancel) {
            return handler.next(
              error.copyWith(
                error: "",
                message: "You have cancelled the request.",
              ),
            );
          }

          if (error.response?.statusCode == 401) {
            final innerContext = MyApp.navigatorKey.currentContext;
            if (innerContext != null) {
              Navigator.pushNamedAndRemoveUntil(
                innerContext,
                AppRoutes.loginViewRoute,
                (route) => false,
              );
              CustomToast.show(
                innerContext,
                message: "Session Expired",
                toastEnum: ToastEnum.information,
              );
            }

            return handler.next(error);
          }

          handler.next(error);
        },
      ),
    );
  }

  Future<Response> request({
    required String url,
    required RequestType requestType,
    Function(CancelToken)? getCancelToken,
    Map<String, dynamic>? body,
    FormData? formData,
    ResponseType? responseType,
  }) async {
    Map<String, dynamic> heading = {
      "x-client-type": "mobile",

      "Content-Type": "application/json",
    };
    Map<String, dynamic> headingWithToken = {
      "x-client-type": "mobile",
      "Content-Type": "application/json",
      // "Authorization": "Bearer ${AppConfig.instance.accessToken}",
    };
    CancelToken cancelToken = CancelToken();
    getCancelToken?.call(cancelToken);
    switch (requestType) {
      case RequestType.get:
        return _dioClient
            .get(
              url,
              data: body,
              cancelToken: cancelToken,
              options: Options(
                headers: heading,
                receiveTimeout: timeOutDuration,
              ),
              onReceiveProgress: (count, total) {
                print("Count:$count");
                print("Total:$total");
              },
            )
            .timeout(timeOutDuration);
      case RequestType.post:
        return _dioClient
            .post(
              url,
              data: body,
              cancelToken: cancelToken,
              options: Options(
                headers: heading,
                receiveTimeout: timeOutDuration,
              ),
            )
            .timeout(timeOutDuration);
      case RequestType.put:
        return _dioClient
            .put(
              url,
              cancelToken: cancelToken,
              options: Options(
                headers: heading,
                receiveTimeout: timeOutDuration,
              ),
            )
            .timeout(timeOutDuration);
      case RequestType.getWithToken:
        return _dioClient
            .get(
              url,
              cancelToken: cancelToken,
              options: Options(
                headers: headingWithToken,
                receiveTimeout: timeOutDuration,
                responseType: responseType,
              ),
            )
            .timeout(timeOutDuration);
      case RequestType.postWithToken:
        return _dioClient
            .post(
              url,
              cancelToken: cancelToken,
              data: body,
              options: Options(
                headers: headingWithToken,
                receiveTimeout: timeOutDuration,
              ),
            )
            .timeout(timeOutDuration);
      case RequestType.putWithToken:
        return _dioClient
            .put(
              url,
              cancelToken: cancelToken,
              data: body,
              options: Options(
                headers: headingWithToken,
                receiveTimeout: timeOutDuration,
              ),
            )
            .timeout(timeOutDuration);

      case RequestType.postWithMultiPartToken:
        return _dioClient
            .post(
              url,
              cancelToken: cancelToken,
              data: formData,
              options: Options(
                headers: headingWithToken,
                receiveTimeout: timeOutDuration,
              ),
            )
            .timeout(timeOutDuration);
    }
  }
}
