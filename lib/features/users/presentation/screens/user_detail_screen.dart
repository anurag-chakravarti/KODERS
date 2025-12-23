import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/user_detail_bloc.dart';
import '../bloc/user_detail_event.dart';
import '../bloc/user_detail_state.dart';

class UserDetailScreen extends StatelessWidget {
  final int userId;
  final UserEntity? initialUser;

  const UserDetailScreen({
    super.key,
    required this.userId,
    this.initialUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserDetailBloc(sl())..add(UserDetailRequested(userId)),
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.userDetailsTitle)),
        body: BlocBuilder<UserDetailBloc, UserDetailState>(
          builder: (context, state) {
            if (state is UserDetailLoaded) {
              return _buildContent(state.user);
            } else if (state is UserDetailError) {
              return Center(child: Text(state.message));
            } else if (state is UserDetailLoading) {
               // Show initial user data if available
               if (initialUser != null) return _buildContent(initialUser!);
               return const Center(child: CircularProgressIndicator());
            } return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildContent(UserEntity user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  gradient: AppColors.loginGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                child: Hero(
                  tag: 'avatar_${user.id}',
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: CachedNetworkImageProvider(user.avatar),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            user.email,
            style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email, color: AppColors.primary),
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person, color: AppColors.primary),
                    title: const Text('User ID'),
                    subtitle: Text('#${user.id}'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
