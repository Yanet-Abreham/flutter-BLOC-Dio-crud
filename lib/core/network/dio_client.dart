import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(milliseconds: ApiConstants.connectionTimeout),
            receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
            responseType: ResponseType.json,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => print('🌐 DIO_LOG: $object'),
      ),
    );
  }

  Dio get dio => _dio;
}