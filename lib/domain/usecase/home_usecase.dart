import 'package:temp/data/network/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:temp/domain/model/models.dart';
import 'package:temp/domain/repository/repository.dart';
import 'package:temp/domain/usecase/base_usecase.dart';

class HomeUseCase implements BaseUseCase<void, HomeObject> {
  final Repository _repository;
  HomeUseCase(this._repository);
  @override
  Future<Either<Failure, HomeObject>> execute(void input) async {
    return await _repository.getHomeData();
  }
}
