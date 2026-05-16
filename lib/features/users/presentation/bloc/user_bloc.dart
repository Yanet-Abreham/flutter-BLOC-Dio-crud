import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(UserInitial()) {
    
    /* Fetch Users */
    on<FetchUsersEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await repository.getUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError("Failed to fetch users: ${e.toString()}"));
      }
    });

    /* Add User */
    on<AddUserEvent>((event, emit) async {
      if (state is UserLoaded) {
        final currentUsers = List<UserModel>.from((state as UserLoaded).users);
        
        final newUser = UserModel(
          id: DateTime.now().millisecondsSinceEpoch, 
          first_Name: event.firstName,
          last_Name: event.lastName,
          email: event.email,
          avatar: 'https://robohash.org/${DateTime.now().millisecondsSinceEpoch}',
        );
        
        currentUsers.insert(0, newUser);
        emit(UserLoaded(currentUsers));
      }
    });

   /* Update User */
   on<UpdateUserEvent>((event, emit){
      if (state is UserLoaded){
        final currentUSers = (state as UserLoaded).users;

        final updatedUsers = currentUSers.map((user) {
          return user.id == event.id ? user.copyWith(
            first_Name: event.firstName,
            last_Name: event.lastName,
            email: event.email,
          )
          : user;
      }).toList();

        emit(UserLoaded(updatedUsers));
      }
    });

   /* Delete User */
    on<DeleteUserEvent>((event, emit) async {
      if (state is UserLoaded) {
        final currentUsers = ((state as UserLoaded).users);
        try {
          final updatedUsers = currentUsers.where((user) => user.id != event.userId).toList();
          emit(UserLoaded(updatedUsers));
        } catch (e) {
          emit(UserError("Failed to delete user"));
        }
      }
    });
  }
}