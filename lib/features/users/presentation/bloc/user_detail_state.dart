import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class UserDetailState extends Equatable {
  const UserDetailState();
  @override
  List<Object?> get props => [];
}

class UserDetailInitial extends UserDetailState {}
class UserDetailLoading extends UserDetailState {}
class UserDetailLoaded extends UserDetailState {
  final UserEntity user;
  const UserDetailLoaded(this.user);
  @override
  List<Object?> get props => [user];
}
class UserDetailError extends UserDetailState {
  final String message;
  const UserDetailError(this.message);
  @override
  List<Object?> get props => [message];
}
