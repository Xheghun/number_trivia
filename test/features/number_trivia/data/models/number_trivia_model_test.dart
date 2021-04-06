import 'dart:convert';

import 'package:clean_tdd/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_tdd/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 40, text: 'Test Text');

  test(
    'shouble be a subclass of NumberTrivia Entity',
    () async {
//assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer',
        () async {
      //arange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      print(result);
      //assert
      expect(result, tNumberTriviaModel);
    });

    test('should return a valid model when the JSON number is a double',
        () async {
      //arange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('trivia_double.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      print(result);
      //assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      //act
      Map<String, dynamic> result = tNumberTriviaModel.toJson();

      final expectedMap = {"text": "Test Text", "number": 40};
      //assert
      expect(result, expectedMap);
    });

 
  });
}
