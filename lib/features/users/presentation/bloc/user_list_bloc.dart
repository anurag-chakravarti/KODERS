import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../../../../core/network/data_state.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'user_list_event.dart';
import 'user_list_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final GetUsersUseCase _getUsersUseCase;

  UserListBloc(this._getUsersUseCase) : super(const UserListState()) {
    on<UserListFetched>(
      _onUserListFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<UserListRefreshed>(_onUserListRefreshed);
  }

  Future<void> _onUserListFetched(UserListFetched event, Emitter<UserListState> emit) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == UserListStatus.initial) {
        final result = await _getUsersUseCase(page: 1);
        if (result is DataSuccess) {
           final data = result.data!;
           return emit(state.copyWith(
            status: UserListStatus.success,
            users: data.users,
            hasReachedMax: data.currentPage >= data.totalPages,
            currentPage: data.currentPage,
          ));
        } else {
          return emit(state.copyWith(status: UserListStatus.failure, errorMessage: result.error?.message));
        }
      }

      final result = await _getUsersUseCase(page: state.currentPage + 1);
      if (result is DataSuccess) {
          final data = result.data!;
          if (data.users.isEmpty) {
            emit(state.copyWith(hasReachedMax: true));
          } else {
            emit(state.copyWith(
              status: UserListStatus.success,
              users: List.of(state.users)..addAll(data.users),
              hasReachedMax: data.currentPage >= data.totalPages,
              currentPage: data.currentPage,
            ));
          }
      } else {
         emit(state.copyWith(status: UserListStatus.failure, errorMessage: result.error?.message));
      }
    } catch (_) {
      emit(state.copyWith(status: UserListStatus.failure, errorMessage: "Unexpected error"));
    }
  }

  Future<void> _onUserListRefreshed(UserListRefreshed event, Emitter<UserListState> emit) async {
    emit(state.copyWith(status: UserListStatus.initial, hasReachedMax: false, currentPage: 1, users: []));
    add(UserListFetched());
  }
}
