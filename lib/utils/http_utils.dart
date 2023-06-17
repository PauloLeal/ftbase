import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../services/shared_preferences_service.dart';

class HttpResponse {
  final http.Response originalResponse;

  int get statusCode => originalResponse.statusCode;
  String get body => utf8.decode(originalResponse.bodyBytes);
  Map<String, dynamic> get toJson => HttpUtils.unmarshalJson(body);

  HttpResponse._private({
    required this.originalResponse,
  });
}

class HttpUtils {
  static final HttpWithMiddleware _httpClient = HttpWithMiddleware.build(middlewares: [
    HttpLogger(logLevel: LogLevel.BODY),
  ]);

  // static final HttpClientWithMiddleware _streamedHttpClient = HttpClientWithMiddleware.build(middlewares: [
  //   HttpLogger(logLevel: LogLevel.BODY),
  // ]);

  static Future<HttpResponse> getJson(
    String url, {
    Map<String, String>? headers,
    bool cached = false,
    bool hasLog = false,
  }) async {
    return _reqJson("get", url, headers: headers, cached: cached, hasLog: hasLog);
  }

  static Future<HttpResponse> postJson(
    String url,
    Map<String, dynamic>? json, {
    Map<String, String>? headers,
    bool cached = false,
    bool hasLog = false,
  }) async {
    return _reqJson("post", url, json: json, headers: headers, cached: cached, hasLog: hasLog);
  }

  static Future<HttpResponse> putJson(
    String url,
    Map<String, dynamic>? json, {
    Map<String, String>? headers,
    bool cached = false,
    bool hasLog = false,
  }) async {
    return _reqJson("put", url, json: json, headers: headers, cached: cached, hasLog: hasLog);
  }

  static Future<HttpResponse> postFile(
    String url,
    Uint8List bytes,
    String filename, {
    Map<String, String>? headers,
  }) async {
    return _reqJson("upload", url, headers: headers, bytes: bytes, filename: filename);
  }

  static String _hashRequest(
    String method,
    String url, {
    Map<String, dynamic>? json,
    Map<String, String>? headers,
  }) {
    String reqString = "$method$url";
    if (json != null) {
      var kl = json.keys.toList();
      kl.sort();

      for (var k in kl) {
        reqString = "$reqString$k=${json[k]}";
      }
    }

    if (headers != null) {
      var kh = headers.keys.toList();
      kh.sort();

      for (var k in kh) {
        reqString = "$reqString$k=${headers[k]}";
      }
    }

    List<int> b = utf8.encode(reqString);
    return sha256.convert(b).toString();
  }

  static Future<HttpResponse> _reqJson(
    String method,
    String url, {
    Map<String, dynamic>? json,
    Map<String, String>? headers,
    String? filename,
    bool cached = false,
    bool hasLog = false,
    Uint8List? bytes,
  }) async {
    SharedPreferencesService ls = SharedPreferencesService.instance;
    headers ??= {};
    bool isUsingCache = false;

    if (!headers.containsKey("content-type")) {
      headers["content-type"] = "application/json";
    }

    int cachedStatus = 0;
    String? cachedBody;

    String reqHash = _hashRequest(method, url, headers: headers, json: json);
    String cacheKeyEtag = "httpreq-$reqHash-etag";
    String cacheKeyBody = "httpreq-$reqHash-body";
    String cacheKeyStatus = "httpreq-$reqHash-status";

    if (cached) {
      cachedBody = await ls.getString(cacheKeyBody);
      String? status = await ls.getString(cacheKeyStatus);
      if (status != null) {
        cachedStatus = int.parse(await ls.getString("httpreq-$reqHash-status") ?? "0");
      }
      String? etag = await ls.getString(cacheKeyEtag);

      if (etag != null && cachedBody != null && status != null) {
        isUsingCache = true;
        headers["If-None-Match"] = etag;
      }
    }

    http.Response response;

    if (method == "upload") {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.files.add(
        http.MultipartFile.fromBytes('fileUpload', bytes!, filename: filename),
      );
      response = await http.Response.fromStream(await request.send());
    } else {
      if (method == "get") {
        response = hasLog
            ? await _httpClient.get(Uri.parse(url), headers: headers)
            : await http.get(Uri.parse(url), headers: headers);
      } else {
        var f = hasLog ? _httpClient.post : http.post;
        if (method == "put") {
          f = hasLog ? _httpClient.put : http.put;
        }
        response = await f(
          Uri.parse(url),
          headers: headers,
          body: json != null ? marshalJson(json) : null,
        );
      }
    }

    HttpResponse ret;
    if (isUsingCache && response.statusCode == 304) {
      response = http.Response(
        cachedBody!,
        cachedStatus,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
        request: response.request,
      );

      ret = HttpResponse._private(originalResponse: response);
    } else {
      ret = HttpResponse._private(originalResponse: response);
    }
    if (cached) {
      ls.putString(cacheKeyBody, response.body);
      ls.putString(cacheKeyStatus, "${response.statusCode}");
      if (response.headers.containsKey("etag")) {
        ls.putString(cacheKeyEtag, response.headers["etag"] ?? "");
      }
    }

    return ret;
  }

  static String marshalJson(Object data) {
    return jsonEncode(data);
  }

  static dynamic unmarshalJson(String json) {
    return jsonDecode(json);
  }
}
