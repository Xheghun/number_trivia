import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// this will get the trivia saved the last time the user had an
  /// internet connection.
  /// Throws  a [CacheException] if there are no cache present
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
