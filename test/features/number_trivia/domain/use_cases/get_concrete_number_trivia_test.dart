import 'package:clean_tdd/core/use_cases/use_case.dart';
import 'package:clean_tdd/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_tdd/feature/number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:clean_tdd/feature/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia for the number from the repository',
    () async {
      //arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      //act
      final result = await useCase(Params(number: tNumber));

      //assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
