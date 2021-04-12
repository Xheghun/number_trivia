import 'package:clean_tdd/core/network/network_info.dart';
import 'package:clean_tdd/core/util/input_converter.dart';
import 'package:clean_tdd/feature/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_tdd/feature/number_trivia/data/data_sources/number_trivia_remote_datasource.dart';
import 'package:clean_tdd/feature/number_trivia/data/repositories/number_trivia_repo_impl.dart';
import 'package:clean_tdd/feature/number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:clean_tdd/feature/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_tdd/feature/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:clean_tdd/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final _locator = GetIt.instance;

Future<void> init() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  //! Features - NumberTrivia
  //bloc
  _locator
    ..registerFactory(() => NumberTriviaBloc(
        concrete: _locator(), converter: _locator(), random: _locator()))

    //use cases
    ..registerLazySingleton(() => GetConcreteNumberTrivia(_locator()))
    ..registerLazySingleton(() => GetRandomNumberTrivia(_locator()))

    //repository
    ..registerLazySingleton<NumberTriviaRepository>(() =>
        NumberTriviaRepositoryImpl(
            remoteDataSource: _locator(),
            localDataSource: _locator(),
            networkInfo: _locator()))

    //Data
    ..registerLazySingleton<NumberTriviaLocalDataSource>(
        () => NumberTriviaLocalDataSourceImpl(sharedPreferences: _locator()))
    ..registerLazySingleton<NumberTriviaRemoteDataSource>(
        () => NumberTriviaRemoteDataSourceImpl(client: _locator()))

    //! Core
    ..registerLazySingleton(() => InputConverter())
    ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(_locator()))

    //! External

    ..registerLazySingleton(() => sharedPreferences)
    ..registerLazySingleton(() => http.Client())
    ..registerLazySingleton(() => DataConnectionChecker());
}
