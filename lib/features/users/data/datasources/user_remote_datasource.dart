import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '/core/constants/api_constants.dart';

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource(this.dio);

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await dio.get(
        ApiConstants.users,
        queryParameters: {'limit': ApiConstants.userFetchLimit},
    );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jsonList = response.data['users'];
        return jsonList.map((json) => UserModel.fromJson(json)).toList();
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