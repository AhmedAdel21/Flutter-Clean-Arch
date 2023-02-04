import 'package:temp/data/network/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:temp/domain/model/models.dart';
import 'package:temp/domain/repository/repository.dart';
import 'package:temp/domain/usecase/base_usecase.dart';

class HomeDataUseCase implements BaseUseCase<void, HomeObject> {
  final Repository _repository;
  HomeDataUseCase(this._repository);
  @override
  Future<Either<Failure, HomeObject>> execute(_) async {
    return await _repository.getHomeData();
  }
}
