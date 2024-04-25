import 'package:dio/dio.dart';
import 'package:notes_final_version/app/utils/console_log_functions.dart';

class API {
  final Dio _dio = Dio();
  static const url = "http://192.168.43.105:8000";

  API() {
    _dio.options.baseUrl = "$url/api";
    // all the request will pass from this interceptor, as we are giving PrettyDioLogget instance
    // _dio.interceptors.add();
  }

  Future<dynamic> get({required String url, String? token}) async {
    try {
      if (token != null) {
        // _dio.options.baseUrl = "/api$url";
        _dio.options.headers['Accept'] = 'application/json';
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      Response response = await _dio.get(url);
      logJSON(object: response.data.toString());
      logInfo("status code: ${response.statusCode ?? 0}");
      if (response.statusCode == 200) {
        var jsonResponse = response.data;
        return jsonResponse;
      }
    } catch (e) {
      logInfo(e.toString());
      if (e is DioError) {
        logError("in get dioerror status code: ${e}");
        logError("e.message: ${e.message}");
        logError("e.response: ${e.response}");
        logError("e.error: ${e.error}");
      }
      rethrow;
    }
  }

  Future<dynamic> post(String url,
      {dynamic data, String? token, String? contentType}) async {
    //options.headers?['accept'] = 'application/json';
    if (token != null) {
      // _dio.options.baseUrl = "/api$url";
      _dio.options.headers['Authorization'] = 'Bearer $token';
      _dio.options.headers['Content-Type'] =
          contentType ?? 'application/x-www-form-urlencoded';
    }

    try {
      Response response = await _dio.post(url, data: data);
      logJSON(object: response.data.toString());
      logSuccess("status code: ${response.statusCode ?? 0}");
      if (response.statusCode == 200) {
        var jsonResponse = response.data;
        return jsonResponse;
      }
    } catch (e) {
      if (e is DioError) {
        logError("in post dioerror status code: ${e}");

        logError("e.message: ${e.message}");
        logError("e.response: ${e.response}");
        logError("e.error: ${e.error}");
      } else {
        logError("in simple error status code: ${e}");
        logError(e.toString());
      }
      rethrow;
    }
  }
}
