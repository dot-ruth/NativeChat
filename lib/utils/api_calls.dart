import 'package:dio/dio.dart';

Future<String> getReddit(parameters) async {
  var subreddit = parameters['subreddit'].toString().trim();
  var time = parameters['time'].toString().trim();
  var listing = parameters['listing'].toString().trim();
  var baseURL =
      'https://www.reddit.com/r/$subreddit/$listing.json?t=$time&limit=20';

  var dio = Dio();
  var result = await dio.get(baseURL);
  var feed = result.data['data']['children'];

  var advancedContext =
      "HERE'S THE CONTENT FROM THE SUBREDDIT $subreddit: $feed";
  return advancedContext;
}
