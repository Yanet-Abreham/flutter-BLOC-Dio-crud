import 'package:dio/dio.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../../../../core/constants/api_constants.dart';

/* Fetches raw user data from the remote API */
class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource(this.dio);

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await dio.get(ApiConstants.users);

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data;
        Map<String, dynamic> parsedData;

        if (rawData is String) {
          parsedData = jsonDecode(rawData) as Map<String, dynamic>;
        } else if (rawData is Map<String, dynamic>) {
          parsedData = rawData;
        } else {
          throw Exception('Unknown payload format layout');
        }

        if (parsedData.containsKey('users')) {
          final List<dynamic> jsonList = parsedData['users'];
          return jsonList.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Missing "users" key in network response');
        }
      } else {
        throw Exception('Failed to load users from server');
      }
    } on DioException catch (dioError) {
      final errorMessage = dioError.response?.data?['message'] ?? dioError.message;
      throw Exception('Network Error: $errorMessage');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}