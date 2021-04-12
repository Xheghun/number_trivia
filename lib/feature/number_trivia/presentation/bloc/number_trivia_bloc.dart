import 'dart:async';
import 'package:clean_tdd/core/error/failures.dart';
import 'package:clean_tdd/core/use_cases/use_case.dart';
import 'package:clean_tdd/core/util/input_converter.dart';
import 'package:clean_tdd/feature/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_tdd/feature/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:meta/meta.dart';
import 'bloc.dart';
import 'package:bloc/bloc.dart';

const String SERVER_FAILRE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_MESSAGE = "Invalid Input";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required GetConcreteNumberTrivia concrete,
      @required GetRandomNumberTrivia random,
      @required InputConverter converter})
      : assert(concrete != null),
        assert(random != null),
        assert(converter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        inputConverter = converter;

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      yield* inputEither.fold((failure) async* {
        yield Error(message: INVALID_INPUT_MESSAGE);
      }, (integer) async* {
        yield Loading();
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        yield failureOrTrivia.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)),
            (trivia) => Loaded(trivia: trivia));
        getConcreteNumberTrivia(Params(number: integer));
      });
    } else if(event is GetTriviaForRandomNumber) {
        yield Loading();
        final failureOrTrivia =
            await getRandomNumberTrivia(NoParams());
        yield failureOrTrivia.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)),
            (trivia) => Loaded(trivia: trivia));
        getRandomNumberTrivia(NoParams());
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILRE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error";
    }
  }

  @override
  NumberTriviaState get initialState => Empty();
}
