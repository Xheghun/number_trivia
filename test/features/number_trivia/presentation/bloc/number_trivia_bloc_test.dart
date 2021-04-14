import 'package:clean_tdd/core/error/failures.dart';
import 'package:clean_tdd/core/use_cases/use_case.dart';
import 'package:clean_tdd/core/util/input_converter.dart';
import 'package:clean_tdd/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_tdd/feature/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_tdd/feature/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:clean_tdd/feature/number_trivia/presentation/bloc/bloc.dart';
import 'package:clean_tdd/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      converter: mockInputConverter,
    );
  });

  test('initial  state should be Empty', () {
    //asert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final int tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    test(
        'should call the InputConverter to validate and convert the string to an unsigned int',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      //assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      //arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      //assert later
      expectLater(
        bloc.state,
        emitsInOrder(
          [
            Empty(),
            Error(message: INVALID_INPUT_MESSAGE),
          ],
        ),
      );

      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => Right(tNumberTrivia));

//assert later
        final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];

        expectLater(bloc.state, emitsInOrder(expected));
//act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

//assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILRE_MESSAGE)
        ];

        expectLater(bloc.state, emitsInOrder(expected));
//act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data from cache fails',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => Left(CacheFailure()));

//assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE)
        ];

        expectLater(bloc.state, emitsInOrder(expected));
//act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('should get data from the random use case', () async {
      //arrange
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(NoParams()));
      //assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        //arrange
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((realInvocation) async => Right(tNumberTrivia));

//assert later
        final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];

        expectLater(bloc.state, emitsInOrder(expected));
//act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        //arrange
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

//assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILRE_MESSAGE)
        ];

        expectLater(bloc.state, emitsInOrder(expected));
//act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data from cache fails',
      () async {
        //arrange
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((realInvocation) async => Left(CacheFailure()));

//assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE)
        ];

        expectLater(bloc.state, emitsInOrder(expected));
//act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
