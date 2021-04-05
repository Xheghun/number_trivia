import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numberapi.com/{number} endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  
  /// Calls the http://numberapi.com/random endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTrivia> getRandomNumberTrivia();
}
