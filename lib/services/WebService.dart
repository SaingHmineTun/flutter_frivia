import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class WebService {
  late Dio dio;
  String? baseUrl;

  WebService() {
    dio = Dio();
  }

  Future loadUrl(String level, int numberOfQuestions, int? categoryItem) async {
    if (baseUrl == null) {
      String str = await rootBundle.loadString("assets/data/main.json");
      Map map = jsonDecode(str);
      baseUrl = map["base_url"];
    }
    Map<String, dynamic> parameters = {"difficulty": level, "amount": numberOfQuestions};
    if (categoryItem != null) {
      parameters['category'] = categoryItem;
    }
    print("Query parameters : $parameters");
    return await dio.get(
      baseUrl!,
      queryParameters: parameters,
    );
  }
}
