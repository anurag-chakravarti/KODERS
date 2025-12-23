import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required int id,
    required String email,
    required String firstName,
    required String lastName,
    required String avatar,
  }) = _UserEntity;
}

@freezed
abstract class PaginatedUsersEntity with _$PaginatedUsersEntity {
  const factory PaginatedUsersEntity({
    required List<UserEntity> users,
    required int totalPages,
    required int currentPage,
  }) = _PaginatedUsersEntity;
}
