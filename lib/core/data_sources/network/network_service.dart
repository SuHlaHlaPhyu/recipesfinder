import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http_interceptor/models/retry_policy.dart';
import 'package:logger/logger.dart';

import '../api_endpoints.dart';
import '../base_service.dart';

class NetworkService implements BaseService {
  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService.instance() => _instance;

  late final Client _client;

  final Logger _logger = Logger();

  NetworkService._internal() {
    _client = InterceptedClient.build(
      requestTimeout: const Duration(seconds: 10),
      interceptors: [],
      retryPolicy: TimeoutRetryPolicy(),
      client: IOClient(HttpClient()),
    );
  }
  @override
  Future<dynamic> getCall(String url, dynamic param) async {
    Uri uri = Uri.https(BASE_URL, url, param);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    try {
      final response = await _client.get(uri, headers: headers);
      _logger.i(response.body);
      return jsonDecode(response.body);
    } on SocketException catch (e) {
      _logger.i('$e');
      throw {"message": "Socket Exception! Failed host lookup"};
    } on TimeoutException catch (e) {
      _logger.i('$e');
      throw {"message": "Request timeout!"};
    } catch (e) {
      _logger.i('$e');
      throw {"message": "$e"};
    }
  }
}

class TimeoutRetryPolicy extends RetryPolicy {
  @override
  int get maxRetryAttempts => 3;

  @override
  Future<bool> shouldAttemptRetryOnException(
    Exception reason,
    BaseRequest request,
  ) async {
    return true;
  }

  @override
  Duration delayRetryAttemptOnResponse({required int retryAttempt}) {
    return Duration(milliseconds: (250 * math.pow(2.0, retryAttempt)).toInt());
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    return false;
  }
}
