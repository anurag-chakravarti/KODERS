import 'package:equatable/equatable.dart';

abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();
  @override
  List<Object?> get props => [];
}

class UserDetailRequested extends UserDetailEvent {
  final int userId;
  const UserDetailRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}
