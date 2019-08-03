import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

Future requestData(url, {formData}) async {
  try {
    print('开始获取数据...............');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse('application/x-www-form-urlencoded');
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口有异常');
    }
  } catch (e) {
    return print('ERROR:........$e');
  }
}

//获取首页主题内容
Future getHomePageContent() {
  return requestData('homePageContent',
      formData: {'lon': '115.02932', 'lat': '35.76189'});
}
