import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../dlna_action_result.dart';
import '../dlna_device.dart';

abstract class AbsDLNAAction<T> {
  static final ContentType contentType =
      ContentType('text', 'xml', charset: 'utf-8');

  Dio httpClient = init();

  DLNADevice dlnaDevice;

  AbsDLNAAction(DLNADevice dlnaDevice) {
    this.dlnaDevice = dlnaDevice;
  }

  static Dio init() {
    Dio http = Dio(BaseOptions(
        connectTimeout: 5000, receiveTimeout: 5000, sendTimeout: 5000));
    final isProd = bool.fromEnvironment('dart.vm.product');
    if (!isProd) {
      http.interceptors.add(LogInterceptor(
          responseBody: false,
          requestBody: false,
          requestHeader: false,
          responseHeader: false));
    }
    return http;
  }

  String getControlURL();

  String getXmlData();

  String getSoapAction();

  Future<DLNAActionResult<T>> execute();

  Future<DLNAActionResult<T>> start() async {
    var url = 'http://' + Uri.parse(dlnaDevice.location).authority;
    var controlURL = getControlURL();
    if (!url.endsWith('/')) {
      url = url + ('/');
    }
    if (controlURL.startsWith('/')) {
      controlURL = controlURL.substring(1);
    }
    url = url + controlURL;
    var content = getXmlData();
    var result = DLNAActionResult<T>();
    try {
      Map<String, dynamic> reqHeaders = Map();
      reqHeaders["Content-Type"] = contentType.toString();
      reqHeaders["Content-Length"] = utf8.encode(content).length;
      reqHeaders["Connection"] = 'Keep-Alive';
      reqHeaders["Charset"] = 'UTF-8';
      reqHeaders["Soapaction"] = getSoapAction();
      Options options = Options(headers: reqHeaders);
      Response response = await httpClient.post(url,data:content,options: options);
      result.httpContent = response.data.toString();
      result.success =
          (response.statusCode == HttpStatus.ok && result.httpContent != null);

    } catch (e) {
      result.success = false;
      result.errorMessage = e.toString();
    }
    return result;
  }
}
