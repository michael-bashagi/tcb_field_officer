import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../farmer_registration/domain/farmer_request.dart';
import '../farmer_registration/presentation/gps_boundary_walker_screen.dart';
import '../features/billing/presentation/registration_summary_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/auth/presentation/controllers/login_screen.dart';
import '../features/home/presentation/home_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String registrationDetails = '/registration-details';
  static const String gpsWalker = '/gps_walker';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.gpsWalker,
        builder: (context, state) => const GpsBoundaryWalkerScreen(),
      ),
      GoRoute(
        path: AppRoutes.registrationDetails,
        builder: (context, state) {
          final farmerRequest = state.extra as FarmerRequest?;
          if (farmerRequest == null) {
            return const Scaffold(
              body: Center(child: Text('Error: Missing registration details')),
            );
          }
          return RegistrationDetailsScreen(farmerRequest: farmerRequest);
        },
      ),
    ],
  );
});
