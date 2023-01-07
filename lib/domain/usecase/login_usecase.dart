import 'package:temp/data/network/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:temp/data/network/requests.dart';
import 'package:temp/domain/model/models.dart';
import 'package:temp/domain/repository/repository.dart';
import 'package:temp/domain/usecase/base_usecase.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  final Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput input) async {
    return await _repository.login(LoginRequest(input.email, input.password));
  }
}

class LoginUseCaseInput {
  String email;
  String password;

  LoginUseCaseInput(this.email, this.password);
}
