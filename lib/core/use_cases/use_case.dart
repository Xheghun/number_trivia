import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../feature/number_trivia/domain/entities/number_trivia.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, NumberTrivia>> call(Params params);
}

class NoParams extends Equatable {}

class Params extends Equatable {
  final int number;

  Params({@required this.number}) : super([number]);
}