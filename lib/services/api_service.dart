import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webtoon/models/webtoon.dart';
import 'package:webtoon/models/webtoon_detail_model.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';

// API에서 JSON파일 받아오기 (Fetching Data)

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];

    // async & await => 데이터를 받아올 때까지 잠깐 기다리는 동작 실행, async 함수만 await 사용 가능
    final url = Uri.parse('$baseUrl/$today');
    final response =
        await http.get(url); // get 함수 리턴값보면.. Future 자료형 = 미래의 값에 대한 자료형,
    // Response 자료형 = Future 상태의 자료형에서 서버로 부터 받은 데이터에 대한 자료형

    if (response.statusCode == 200) {
      final List<dynamic> webtoons =
          jsonDecode(response.body); // JSON파일 형식 [{blah blah},{}, .. ,{}]
      for (var webtoon in webtoons) {
        // JSON 데이터를 가공하기,  하나씩 꺼내서 named constructor에 대입하여 instance로 만듦
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLastestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse('$baseUrl/$id/episodes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
