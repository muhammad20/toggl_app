import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:toggl_app/data/web/base/token-provider.dart';

/// In charge of sending the HTTP request, wrapper class for the http client.
class WebClient {
  final String _baseUrl = "https://api.track.toggl.com/api/v8/";

  final _headers = new Map<String, String>();

  ITokenProvider _tokenProvider;

  WebClient({ITokenProvider tokenProvider}) {
    _headers["Content-Type"] = "application/json";
    this._tokenProvider = tokenProvider;
  }

  void addHeader(String key, String value) {
    _headers[key] = value;
  }

  Future<http.Response> _get(String fullUrl) {
    return http.get(fullUrl, headers: _headers);
  }

  Future<http.Response> _post(String fullUrl, dynamic body) async {
    return http.post(fullUrl, body: body, headers: _headers);
  }

  Future<http.Response> _put(String fullUrl, dynamic body) async {
    return http.put(fullUrl, body: body, headers: _headers);
  }

  /// Sends a request and returns a future of JSON map
  Future<dynamic> request(String route, HttpMethod method,
      {String authToken,
      Map<String, dynamic> body,
      Map<String, String> queries}) async {
    if (this._tokenProvider != null) {
      var token = await this._tokenProvider.getToken();

      if (token != null) {
        // construct authorization header according to toggl API v8 specification.
        String credentials = '$token:api_token';
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String encoded = stringToBase64.encode(credentials);
        _headers['Authorization'] = 'Basic $encoded';
      }
    }

    if (queries != null) {
      route += '?';
      queries.forEach((key, value) => route += '$key=$value&');
      route = route.substring(0, route.length - 1);
    }

    String fullUrl = _baseUrl + route;

    http.Response res;
    switch (method) {
      case HttpMethod.GET:
        res = await _get(fullUrl);
        break;
      case HttpMethod.POST:
        res = await _post(fullUrl, json.encode(body));
        break;
      case HttpMethod.PUT:
        res = await _put(fullUrl, json.encode(body));
    }

    if (res.statusCode.toString().startsWith('2')) {
      var value = json.decode(res.body);
      return value;
    } else if (res.statusCode == 403) {
      return {"status": "unauthorized"};
    } else {
      throw new Exception();
    }
  }
}

enum HttpMethod { GET, POST, PUT }
