// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_proh/common/theme/theme.dart';
import 'package:shop_proh/common/widgets/bottom_bar.dart';
import 'package:shop_proh/constants/globalvariable.dart';
import 'package:shop_proh/features/admin/screens/dash_board_admin_screen.dart';
import 'package:shop_proh/features/auth/screens/auth_screen.dart';
import 'package:shop_proh/features/auth/services/auth_service.dart';
import 'package:shop_proh/providers/theme_provider.dart';
import 'package:shop_proh/providers/user_provider.dart';
import 'package:shop_proh/route.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(
            create: (context) => ThemeProvider(isDark: false)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Proh',
      home: Scaffold(
        // Đặt MaterialApp trong một Scaffold
        body:
            _MyAppBody(), // Bạn có thể thay đổi thành tên widget bạn muốn sử dụng
      ),
    );
  }
}

class _MyAppBody extends StatefulWidget {
  @override
  State<_MyAppBody> createState() => _MyAppBodyState();
}

class _MyAppBodyState extends State<_MyAppBody> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Proh',
      theme: ThemeData(
        scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      darkTheme: darkMode,
      themeMode: Provider.of<ThemeProvider>(context).isDark
          ? ThemeMode.dark
          : ThemeMode.light,
      onGenerateRoute: (settings) => generateRoute(settings),
      // Kiểm tra nếu đã có token người dùng
      home: userProvider.user.token.isNotEmpty
          ? userProvider.user.type == 'user'
              ? const BottomBar()
              : const DashBoardAdminScreen()
          : const AuthScreen(),
    );
  }
}
