import 'package:temp/data/data_source/local_data_source.dart';
import 'package:temp/data/data_source/remote_data_source.dart';
import 'package:temp/data/mapper/mapper.dart';
import 'package:temp/data/network/error_handler.dart';
import 'package:temp/data/network/network_info.dart';
import 'package:temp/data/response/responses.dart';
import 'package:temp/domain/model/models.dart';
import 'package:temp/data/network/requests.dart';
import 'package:temp/data/network/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:temp/domain/repository/repository.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(
      this._networkInfo, this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        // it's connected to the internet so it's safe to call API
        final AuthenticationResponse response =
            await _remoteDataSource.login(loginRequest);
        if (response.status == ApiInternalStatus.success) {
          // success -- return either right, data
          return Right(response.toDomain());
        } else {
          // failure  -- return either left, business error
          return Left(Failure(ApiInternalStatus.failure,
              response.message ?? ResponseMessage.none));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // failure -- return either left, internet connection error
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        // it's connected to the internet so it's safe to call API
        final AuthenticationResponse response =
            await _remoteDataSource.register(registerRequest);
        if (response.status == ApiInternalStatus.success) {
          // success -- return either right, data
          return Right(response.toDomain());
        } else {
          // failure  -- return either left, business error
          return Left(Failure(ApiInternalStatus.failure,
              response.message ?? ResponseMessage.none));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // failure -- return either left, internet connection error
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, ForgetPasswordSupportMessage>> forgetPassword(
      ForgetPasswordRequest forgetPasswordRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        // it's connected to the internet so it's safe to call API
        final ForgetPasswordSupportMessageResponse response =
            await _remoteDataSource.forgetPassword(forgetPasswordRequest);
        if (response.status == ApiInternalStatus.success) {
          // success -- return either right, data
          return Right(response.toDomain());
        } else {
          // failure  -- return either left, business error
          return Left(Failure(ApiInternalStatus.failure,
              response.message ?? ResponseMessage.none));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // failure -- return either left, internet connection error
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    try {
      // get response from cache
      final HomeResponse response = _localDataSource.getHomeData();
      return Right(response.toDomain());
    } catch (cacheError) {
      // the cache does not exist or is not valid
      // it is the time to get the data from API side
      if (await _networkInfo.isConnected) {
        try {
          // it's connected to the internet so it's safe to call API
          final HomeResponse response = await _remoteDataSource.getHomeData();
          if (response.status == ApiInternalStatus.success) {
            // success -- return either right, data
            // save response in cache (localDataSource)
            _localDataSource.saveHomeToCache(response);
            return Right(response.toDomain());
          } else {
            // failure  -- return either left, business error
            return Left(Failure(ApiInternalStatus.failure,
                response.message ?? ResponseMessage.none));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        // failure -- return either left, internet connection error
        return Left(DataSource.noInternetConnection.getFailure());
      }
    }
  }
}
