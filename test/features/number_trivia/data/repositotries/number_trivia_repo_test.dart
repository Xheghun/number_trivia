import 'package:clean_tdd/core/error/exceptions.dart';
import 'package:clean_tdd/core/error/failures.dart';
import 'package:clean_tdd/core/platform/network_info.dart';
import 'package:clean_tdd/feature/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_tdd/feature/number_trivia/data/data_sources/number_trivia_remote_datasource.dart';
import 'package:clean_tdd/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_tdd/feature/number_trivia/data/repositories/number_trivia_repo_impl.dart';
import 'package:clean_tdd/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

main() {
  NumberTriviaRepositoryImpl repositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repositoryImpl = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('getConcreteNumberTrivia', () {
    final int tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device has internet connection', () async {
      //arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);

      //act
      repositoryImpl.getConcreteNumberTrivia(tNumber);

      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should cache data locally', () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        await repositoryImpl.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivia));
      });
    });

    test(
        'should return server failure when the call to remote data source is not successful',
        () async {
      //arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenThrow(ServerException());

      //act
      final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

      //assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(Left(ServerFailure())));
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });

      test('', () {});
    });
  });
}
