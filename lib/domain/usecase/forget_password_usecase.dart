import 'package:temp/data/network/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:temp/data/network/requests.dart';
import 'package:temp/domain/model/models.dart';
import 'package:temp/domain/repository/repository.dart';
import 'package:temp/domain/usecase/base_usecase.dart';

class ForgetPasswordUseCase
    implements
        BaseUseCase<ForgetPasswordUseCaseInput, ForgetPasswordSupportMessage> {
  final Repository _repository;

  ForgetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, ForgetPasswordSupportMessage>> execute(
      ForgetPasswordUseCaseInput input) async {
    return await _repository.forgetPassword(ForgetPasswordRequest(input.email));
  }
}

class ForgetPasswordUseCaseInput {
  String email;

  ForgetPasswordUseCaseInput(this.email);
}
