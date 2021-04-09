import 'dart:convert';

import 'package:clean_tdd/core/constants/keys.dart';
import 'package:clean_tdd/core/error/exceptions.dart';
import 'package:clean_tdd/feature/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_tdd/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
    test(
        'should return NumberTrivia from SharedPreferences when there\'s  one in the cache',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      //act
      final result = await dataSource.getLastNumberTrivia();

      //assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA_KEY));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw CacheException when there\'s no cached value', () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      //act
      final call = dataSource.getLastNumberTrivia;

      //assert
      expect(() => call(),
          throwsA(isInstanceOf<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call SharedPreferences to cache the data', () async {
      //act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA_KEY, expectedJsonString));
    });
  });
}
