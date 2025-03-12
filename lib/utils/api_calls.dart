import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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

Future<String> getCurrentLocation() async {
  await Permission.location.request();
  
  Position position = await Geolocator.getCurrentPosition();
  var lat = position.latitude;
  var lon = position.longitude;
  
  var baseURL =
      "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon";

  var dio = Dio();
  var result = await dio.get(baseURL);
  var address = result.data['display_name'];

  var advancedContext = "CURRENT LOCATION IS ${address}";
  return advancedContext;
}
