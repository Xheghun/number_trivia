import '../../../../core/use_cases/use_case.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repo.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}
