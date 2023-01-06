import 'package:dio/dio.dart';
import 'package:temp/app/constants.dart';

const String applicationJson = "application/json";
const String contentType = "content-type";
const String accept = "accept";
const String authorization = "authorization";
const String defaultLanguage = "language";

class DioFactory {
  Future<Dio> get getDio async {
    Dio dio = Dio();
    int timeOut = Constants.apiRequestTimeOut;
    Map<String, String> header = {
      contentType: applicationJson,
      accept: applicationJson,
      authorization: "send token here",
      defaultLanguage: "en"
    };
    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: header,
      sendTimeout: timeOut,
      receiveTimeout: timeOut,
    );
    return dio;
  }
}
