import 'package:dartz/dartz.dart';
import 'package:temp/data/network/failure.dart';
import 'package:temp/data/network/requests.dart';
import 'package:temp/domain/model/models.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);

  Future<Either<Failure, ForgetPasswordSupportMessage>> forgetPassword(
      ForgetPasswordRequest loginRequest);

  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest);
}
