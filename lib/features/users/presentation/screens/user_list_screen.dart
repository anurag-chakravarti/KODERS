import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/user_list_bloc.dart';
import '../bloc/user_list_event.dart';
import '../bloc/user_list_state.dart';
import '../widgets/user_item.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserListBloc>(
      create: (_) => UserListBloc(sl())..add(UserListFetched()),
      child: const _UserListView(),
    );
  }
}

class _UserListView extends StatefulWidget {
  const _UserListView();

  @override
  State<_UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<_UserListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<UserListBloc>().add(UserListFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.usersTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LoggedOut());
              // Router listener will redirect
            },
          ),
        ],
      ),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          switch (state.status) {
            case UserListStatus.failure:
               return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${AppStrings.fetchUsersFailed}: ${state.errorMessage}'),
                    ElevatedButton(
                      onPressed: () => context.read<UserListBloc>().add(UserListRefreshed()),
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            case UserListStatus.initial:
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: 10,
                itemBuilder: (context, index) => const UserItemShimmer(),
              );
            case UserListStatus.success:
              if (state.users.isEmpty) {
                return const Center(child: Text(AppStrings.noUsersFound));
              }
              return RefreshIndicator(
                onRefresh: () async {
                   context.read<UserListBloc>().add(UserListRefreshed());
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.hasReachedMax
                      ? state.users.length
                      : state.users.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.users.length) {
                      return const UserItemShimmer();
                    }
                    final user = state.users[index];
                    return UserItem(
                      user: user,
                      onTap: () => context.push('/users/${user.id}', extra: user),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
