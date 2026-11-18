import '../models/drama_model.dart';

abstract class DramaDataSource {
  Future<List<DramaModel>> fetchAll();
}