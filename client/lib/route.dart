import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/admin_screen.dart';
import 'screens/employee_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/payroll_screen.dart';

import 'widgets/navbar_admin.dart';
import 'widgets/navbar_user.dart';

final GoRouter router = GoRouter(
  initialLocation: "/login",

  routes: [
    // ==============================
    // ADMIN NAVIGATION
    // ==============================
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => Scaffold(
        body: shell,
        bottomNavigationBar: NavbarAdmin(navigationShell: shell),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/admin",
              builder: (context, state) => const AdminScreen(),
            ),
            GoRoute(
              path: "/admin/employee",
              builder: (context, state) => const EmployeeScreen(),
            ),
          ],
        ),
      ],
    ),

    // ==============================
    // USER NAVIGATION
    // ==============================
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => Scaffold(
        body: shell,
        bottomNavigationBar: NavbarUser(navigationShell: shell),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/home",
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/profile",
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // ==============================
    // AUTH ROUTES
    // ==============================
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/forgot-password",
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: "/change-password",
      builder: (context, state) => const ChangePasswordScreen(),
    ),

    // ==============================
    // PAYROLL ROUTE
    // ==============================
    GoRoute(
      path: "/payroll",
      builder: (context, state) => const PayrollScreen(),
    ),
  ],
);
