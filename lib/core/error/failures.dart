import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  ServerFailure([List properties = const<dynamic>[]]);

  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  CacheFailure([List properties = const<dynamic>[]]);

  @override
  List<Object?> get props => [];
}