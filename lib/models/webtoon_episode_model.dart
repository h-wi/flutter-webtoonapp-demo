class WebtoonEpisodeModel {
  final String id, title, rating, date;

  WebtoonEpisodeModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        id = json['id'],
        rating = json['rating'],
        date = json['date'];
}
