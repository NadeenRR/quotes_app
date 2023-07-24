import 'package:http/http.dart' as http;

import '../models/images_model.dart';
import '../models/quots_model.dart';

class Api {
  String category = '';
  Future<RandomeQuots> getRandomQuot() async {
    final response =
        await http.get(Uri.parse('https://api.quotable.io/random'));
    if (response.statusCode == 200) {
      RandomeQuots jsonDecode = randomeQuotsFromJson(response.body);
      category = jsonDecode.tags[0];
      return jsonDecode;
    }
    return Future.error('error');
  }

  Future<RandomeImage> getRandomImage() async {
    final response = await http.get(
      Uri.parse(
          'https://random.imagecdn.app/v1/image?&category=$category&format=json'),
    );
    if (response.statusCode == 200) {
      RandomeImage jsonDecode = randomeImageFromJson(response.body);
      return jsonDecode;
    }
    return Future.error('error');
  }
}
