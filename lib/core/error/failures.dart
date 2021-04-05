import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([List props = const <dynamic>[]]) : super(props);
}

//General Failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
