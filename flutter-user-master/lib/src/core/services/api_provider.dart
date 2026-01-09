// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// import 'package:alice/core/alice_http_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:tagyourtaxi_driver/src/data/models/http_result.dart';

import 'functions.dart';

class ApiProvider {
  static Duration durationTimeout = const Duration(seconds: 30);

  Future<HttpResult> postRequest(url, body) async {
    final dynamic headers = header();

    if (kDebugMode) {
      log(url.toString());
      log(headers.toString());
      log(json.encode(body).toString());
    }

    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: json.encode(body),
          )
          .timeout(durationTimeout);
      // .interceptWithAlice(alice, body: body);

      return result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        error: '',
        result: "Network",
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        error: '',
        result: "Network",
      );
    }
  }

  Future<HttpResult> postMultiRequest(http.MultipartRequest request) async {
    final Map<String, String> headers = header(isMultipart: true);
    request.headers.addAll(headers);
    if (kDebugMode) {
      log(request.url.toString());
      log(request.headers.toString());
      log(request.fields.toString());
      log(request.files.toString());
    }
    var response = await request.send();
    var responseData = await http.Response.fromStream(response);
    // .interceptWithAlice(alice);
    if (kDebugMode) {
      log(responseData.statusCode.toString());
      log(responseData.body);
    }
    return result(responseData);
  }

  Future<HttpResult> getRequest(url, {bool isHeader = true}) async {
    final dynamic headers = header();
    if (kDebugMode) {
      log(url.toString());
      log(headers.toString());
    }
    try {
      http.Response response = await http
          .get(Uri.parse(url), headers: isHeader ? headers : null)
          .timeout(durationTimeout);
      // .interceptWithAlice(alice);

      return result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        error: '',
        result: "Network",
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        error: '',
        result: "Network",
      );
    }
  }

  ///http DELETE Request
  Future<HttpResult> deleteRequest(url) async {
    final dynamic headers = header();
    if (kDebugMode) {
      log(url.toString());
      log(headers.toString());
    }

    try {
      http.Response response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(durationTimeout); //.interceptWithAlice(alice);
      return result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        error: '',
        result: "Network",
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        error: '',
        result: "Network",
      );
    }
  }

  Future<HttpResult> putRequest(url, body) async {
    final Map<String, String> headers = header();
    if (kDebugMode) {
      log(url);
      log(headers.toString());
      log(json.encode(body));
    }
    try {
      http.Response response = await http
          .put(Uri.parse(url), headers: headers, body: json.encode(body))
          .timeout(durationTimeout);
      // .interceptWithAlice(alice, body: body);

      return result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        error: '',
        result: "Internet error",
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        error: '',
        result: "Internet error",
      );
    }
  }

  Future<HttpResult> patchRequest(url, body) async {
    final Map<String, String> headers = header();
    if (kDebugMode) {
      log('//// ==== ////  PATCH REQUEST //// ==== ////');
      log(url);
      log(body.toString());
      log(headers.toString());
    }
    try {
      http.Response response = await http
          .patch(Uri.parse(url), headers: headers, body: json.encode(body))
          .timeout(durationTimeout);
      // .interceptWithAlice(alice);

      return result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        error: '',
        result: "Internet error",
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        error: '',
        result: "Internet error",
      );
    }
  }

  HttpResult result(response) {
    if (kDebugMode) {
      log(response.body.toString());
      log(response.statusCode.toString());
    }
    int status = response.statusCode ?? 404;

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return HttpResult(
        isSuccess: true,
        status: status,
        result: json.decode(utf8.decode(response.bodyBytes)),
      );
    } else if (response.statusCode == 401) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      return HttpResult(
        isSuccess: false,
        status: status,
        result: result,
      );
    } else if (response.statusCode == 409) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      return HttpResult(
        isSuccess: false,
        status: status,
        result: result,
      );
    } else {
      try {
        var result = json.decode(utf8.decode(response.bodyBytes));
        return HttpResult(
          isSuccess: false,
          status: status,
          result: result,
        );
      } catch (_) {
        return HttpResult(
          isSuccess: false,
          status: status,
          error: '',
          result: "Server error",
        );
      }
    }
  }

  Map<String, String> header({
    bool isMultipart = false,
  }) {
    return bearerToken[0].token == ""
        ? {
            "Accept": "application/json",
            "lang": "en",
            'content-type': 'application/json; charset=utf-8',
          }
        : {
            'content-type':
                isMultipart ? "multipart/form-data" : 'application/json',
            'Accept': isMultipart ? '*/*' : 'application/json',
            "lang": "en",
            "Authorization": "Bearer ${bearerToken[0].token}",
          };
  }
}
