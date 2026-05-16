import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/* Fetch Users Event */
class FetchUsersEvent extends UserEvent {}

/* Create User Event */
class AddUserEvent extends UserEvent {
  final String firstName;
  final String lastName;
  final String email;

  const AddUserEvent({
    required this.firstName, 
    required this.lastName, 
    required this.email
    });

  @override
  List<Object?> get props => [firstName, lastName, email];
}

/* Update User Event */
class UpdateUserEvent extends UserEvent {
  final int id;
  final String firstName;
  final String lastName;
  final String email;

  const UpdateUserEvent({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, email];
}

/* Delete User Event */
class DeleteUserEvent extends UserEvent {
  final int userId;
  const DeleteUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}