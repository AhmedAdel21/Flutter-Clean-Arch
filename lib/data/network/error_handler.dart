import 'package:dio/dio.dart';
import 'package:temp/data/network/failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioError) {
      failure = _handleApiError(error); // handle
    } else {
      failure = DataSource.none.getFailure();
    }
  }
}

Failure _handleApiError(DioError error) {
  switch (error.type) {
    case DioErrorType.response:
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        return Failure(error.response?.statusCode! ?? 0,
            error.response?.statusMessage ?? "");
      } else {
        return DataSource.none.getFailure();
      }
    case DioErrorType.connectTimeout:
      return DataSource.connectionTimeOut.getFailure();
    case DioErrorType.sendTimeout:
      return DataSource.sendTimeOut.getFailure();
    case DioErrorType.receiveTimeout:
      return DataSource.receiveTimeOut.getFailure();
    case DioErrorType.cancel:
      return DataSource.cancel.getFailure();
    case DioErrorType.other:
      return DataSource.none.getFailure();
  }
}

enum DataSource {
  none,
  success,
  noContent,
  badRequest,
  forbidden,
  unauthorized,
  notFound,
  internalServerError,
  connectionTimeOut,
  cancel,
  receiveTimeOut,
  sendTimeOut,
  cacheError,
  noInternetConnection,
  ;

  Failure getFailure() {
    switch (this) {
      case DataSource.success:
        return Failure(ResponseCode.success, ResponseMessage.success);
      case DataSource.noContent:
        return Failure(ResponseCode.noContent, ResponseMessage.noContent);
      case DataSource.badRequest:
        return Failure(ResponseCode.badRequest, ResponseMessage.badRequest);
      case DataSource.forbidden:
        return Failure(ResponseCode.forbidden, ResponseMessage.forbidden);
      case DataSource.unauthorized:
        return Failure(ResponseCode.unauthorized, ResponseMessage.unauthorized);
      case DataSource.notFound:
        return Failure(ResponseCode.notFound, ResponseMessage.notFound);
      case DataSource.internalServerError:
        return Failure(ResponseCode.internalServerError,
            ResponseMessage.internalServerError);
      case DataSource.connectionTimeOut:
        return Failure(
            ResponseCode.connectionTimeOut, ResponseMessage.connectionTimeOut);
      case DataSource.cancel:
        return Failure(ResponseCode.cancel, ResponseMessage.cancel);
      case DataSource.receiveTimeOut:
        return Failure(
            ResponseCode.receiveTimeOut, ResponseMessage.receiveTimeOut);
      case DataSource.sendTimeOut:
        return Failure(ResponseCode.sendTimeOut, ResponseMessage.sendTimeOut);
      case DataSource.cacheError:
        return Failure(ResponseCode.cacheError, ResponseMessage.cacheError);
      case DataSource.noInternetConnection:
        return Failure(ResponseCode.noInternetConnection,
            ResponseMessage.noInternetConnection);
      case DataSource.none:
        return Failure(ResponseCode.none, ResponseMessage.none);
    }
  }
}

class ResponseCode {
  static const int success = 200; // success with data
  static const int noContent = 201; // success with no data (no content)
  static const int badRequest = 400; // failure, API rejected request
  static const int unauthorized = 401; // failure, user is not authorized
  static const int forbidden = 403; //  failure, API rejected request
  static const int notFound = 404; // failure, Not found
  static const int internalServerError = 500; // failure, crash in server side

  // local status code
  static const int connectionTimeOut = -1; //
  static const int cancel = -2; //
  static const int receiveTimeOut = -3; //
  static const int sendTimeOut = -4; //
  static const int cacheError = -5; //
  static const int noInternetConnection = -6; //
  static const int none = -7; //
}

class ResponseMessage {
  static const String success = "success"; // success with data
  static const String noContent =
      "success"; // success with no data (no content)
  static const String badRequest =
      "Bad request, Try again later"; // failure, API rejected request
  static const String unauthorized =
      "User is unauthorized, Try again later"; // failure, user is not authorized
  static const String forbidden =
      "Forbidden request, Try again later"; //  failure, API rejected request
  static const String notFound =
      "Not Found, Try again later"; // failure, crash in server side
  static const String internalServerError =
      "Some thing went wrong, Try again later"; // failure, crash in server side

  // local status code
  static const String connectionTimeOut = "Time out error, Try again later"; //
  static const String cancel = "Request was cancelled, Try again later"; //
  static const String receiveTimeOut = "Time out error, Try again later"; //
  static const String sendTimeOut = "Time out error, Try again later"; //
  static const String cacheError = "Cache error, Try again later"; //
  static const String noInternetConnection =
      "Please check your internet connection"; //
  static const String none = "Some thing went wrong, Try again later"; //
}

class ApiInternalStatus {
  static const success = 0;
  static const failure = 1;
}
