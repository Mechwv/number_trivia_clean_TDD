import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class HttpNumberTriviaRemoteDataSource implements NumberTriviaRemoteDataSource {
  final http.Client httpClient;

  HttpNumberTriviaRemoteDataSource({required this.httpClient});

  Future<NumberTriviaModel> getTrivia(String url) async {
    final response = await httpClient.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number) async {
    return getTrivia('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return getTrivia('http://numbersapi.com/random');
  }
}
