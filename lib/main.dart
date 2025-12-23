import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We register AuthBloc here so it is available globally
    // We use the simpler manual registration for AuthBloc in DI 
    // or just creating it here if it wasn't a singleton.
    // However, AppRouter uses the singleton, so we need to ensure it syncs.
    // Best practice: Register AuthBloc in DI as Factory or Singleton, use it here.
    
    // We will register AuthBloc in DI (updating injection container) or manually create it here
    // Let's create it here for simplicity of lifecycle, but since AppRouter calls GetIt<AuthBloc>,
    // we MUST register it in DI.
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(AppStarted()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Koders Assessment',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: di.sl<AppRouter>().router,
      ),
    );
  }
}
