import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/exceptions.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';

import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {

  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const NumberTriviaRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int? number) async {
    networkInfo.isConnected;
    try {
      final remoteTrivia = await remoteDataSource.getConcreteNumberTrivia(
          number);
      localDataSource.cacheNumberTrivia(remoteTrivia);
      // i love null safety (!true)
      return Right(remoteTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }

}