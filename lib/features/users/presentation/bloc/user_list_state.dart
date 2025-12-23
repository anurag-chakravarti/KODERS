import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

enum UserListStatus { initial, success, failure }

class UserListState extends Equatable {
  final UserListStatus status;
  final List<UserEntity> users;
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;

  const UserListState({
    this.status = UserListStatus.initial,
    this.users = const <UserEntity>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage,
  });

  UserListState copyWith({
    UserListStatus? status,
    List<UserEntity>? users,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
  }) {
    return UserListState(
      status: status ?? this.status,
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, users, hasReachedMax, currentPage, errorMessage];
}
