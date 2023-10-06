import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/theme.dart';
import 'data/repositories/repositories.dart';
import 'firebase_options.dart';
import 'logic/blocs/blocs.dart';
import 'logic/cubits/cubits.dart';
import 'logic/debug/app_bloc_observer.dart';
import 'presentation/router/app_router.dart';
import 'services/notification_services.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  await NotificationServices().initNotification();

  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (_) => UserRepository(),
        ),
        RepositoryProvider(
          create: (_) => CategoryRepository(),
        ),
        RepositoryProvider(
          create: (_) => ProductRepository(),
        ),
        RepositoryProvider(
          create: (_) => WishlistRepository(),
        ),
        RepositoryProvider(
          create: (_) => CartRepository(),
        ),
        RepositoryProvider(
          create: (_) => OrderRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppBloc(
              authRepository: context.read<AuthRepository>(),
              userRepository: context.read<UserRepository>(),
            )..add(AppInitialize()),
          ),
          BlocProvider(create: (_) => NavigatonBarCubit()),
          BlocProvider(
            create: (context) => CategoryBloc(
              categoryRepository: context.read<CategoryRepository>(),
            )..add(LoadCategories()),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              productRepository: context.read<ProductRepository>(),
            )..add(LoadProducts()),
          ),
          BlocProvider(
            create: (context) => WishlistBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(LoadWishlist()),
          ),
          BlocProvider(
            create: (context) => CartBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(LoadCart()),
          ),
          BlocProvider(
            create: (context) => CheckoutBloc()..add(LoadCheckout()),
          ),
          BlocProvider(
            create: (context) => OrderBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(LoadOrder()),
          ),
        ],
        child: MaterialApp(
          scrollBehavior: CustomScrollBehavior(),
          debugShowCheckedModeBanner: false,
          title: 'Flutter eShop',
          theme: AppTheme.lightTheme,
          navigatorKey: navigatorKey,
          initialRoute: AppRouter.initialRoute,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
