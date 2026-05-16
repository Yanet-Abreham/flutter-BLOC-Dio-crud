import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepository(this.remoteDataSource);
  Future<List<UserModel>> getUsers() async {
    try {
      return await remoteDataSource.fetchUsers();
    } catch (e) {
      rethrow; 
    }
  }
}