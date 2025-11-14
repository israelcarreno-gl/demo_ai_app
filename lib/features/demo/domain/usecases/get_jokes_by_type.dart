import 'package:demoai/core/utils/typedef.dart';
import 'package:demoai/features/demo/domain/entities/joke.dart';
import 'package:demoai/features/demo/domain/repositories/joke_repository.dart';

/// Use case to get jokes by type
class GetJokesByType {

  GetJokesByType(this._repository);
  final JokeRepository _repository;

  ResultFuture<List<Joke>> call(String type) async {
    return _repository.getJokesByType(type);
  }
}
