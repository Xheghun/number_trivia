import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/keys.dart';
import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// this will get the trivia saved the last time the user had an
  /// internet connection.
  /// Throws  a [CacheException] if there are no cache present
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA_KEY,
        jsonEncode(
          triviaToCache.toJson(),
        ));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final String jsonString =
        sharedPreferences.getString(CACHED_NUMBER_TRIVIA_KEY);
    if (jsonString != null)
      return Future.value(NumberTriviaModel.fromJson(jsonDecode(jsonString)));
    else
      throw CacheException();
  }
}
