import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String name,
    required String email,
    // JSONPlaceholder doesn't have avatar, we'll generate one
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

extension UserModelMapper on UserModel {
  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        firstName: name.split(' ').first,
        lastName: name.split(' ').length > 1 ? name.split(' ').last : '',
        avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=$id', // Generate avatar
      );
}

// JSONPlaceholder returns a List<UserModel> directly, not a paginated response object.
// We need to handle that in the repository or adapt the model.
// But our Repository expects a paginated response? 
// Actually GetUsersUseCase expects PaginatedUsersEntity.
// We can simulate pagination or just return all.
