import 'dart:convert';
import 'dart:io';

import 'package:clean_tdd/core/error/exceptions.dart';
import 'package:clean_tdd/feature/number_trivia/data/models/number_trivia_model.dart';

import '../../domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

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

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) async {
    return await _getNumberTrivia("http://numbersapi.com/$number");
  }

  @override
  Future<NumberTrivia> getRandomNumberTrivia() async {
    return await _getNumberTrivia("http://numbersapi.com/random");
  }

  Future<NumberTrivia> _getNumberTrivia(String url) async {
    final response = await client
        .get(url, headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode > 199 && response.statusCode < 300)
      return NumberTriviaModel.fromJson(jsonDecode(response.body));

    throw ServerException();
  }
}
