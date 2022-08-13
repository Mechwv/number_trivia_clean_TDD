import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivia from SharedPreferences where there is one in the cache',
      () async {
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));

        final result = await dataSource.getLastNumberTrivia();

        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should return NumberTrivia from SharedPreferences where there isn`t one in the cache',
      () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        final call = dataSource.getLastNumberTrivia;

        expect(() => call(), throwsA(isA<CacheException>()));
      },
    );
  });

  group(
    'cacheNumberTrivia',
    () {
      final tNumberTriviaModel =
          NumberTriviaModel(number: 1, text: 'test trivia');
      test(
        'should call SharedPreferences to cache the data',
        () {
          when(mockSharedPreferences.setString(any, any))
              .thenAnswer((_) async => true);

          dataSource.cacheNumberTrivia(tNumberTriviaModel);

          final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());

          verify(mockSharedPreferences.setString(
              CACHED_NUMBER_TRIVIA, expectedJsonString));
        },
      );
    },
  );
}
