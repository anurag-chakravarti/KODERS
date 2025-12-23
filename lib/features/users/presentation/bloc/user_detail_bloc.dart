import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/data_state.dart';
import '../../domain/repositories/user_repository.dart';
import 'user_detail_event.dart';
import 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final UserRepository _userRepository;

  UserDetailBloc(this._userRepository) : super(UserDetailInitial()) {
    on<UserDetailRequested>(_onUserDetailRequested);
  }

  Future<void> _onUserDetailRequested(UserDetailRequested event, Emitter<UserDetailState> emit) async {
    emit(UserDetailLoading());
    final result = await _userRepository.getUserDetails(event.userId);
    if (result is DataSuccess) {
      emit(UserDetailLoaded(result.data!));
    } else {
      emit(UserDetailError(result.error?.message ?? "Error"));
    }
  }
}
