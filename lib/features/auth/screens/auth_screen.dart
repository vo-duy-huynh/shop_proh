import 'package:flutter/material.dart';
import 'package:shop_proh/features/auth/screens/forgotpass_screen.dart';
import 'package:shop_proh/features/auth/screens/register_screen.dart';
import 'package:shop_proh/features/auth/services/auth_service.dart';
import 'package:shop_proh/features/auth/widgets/gradient_button.dart';
import 'package:shop_proh/features/auth/widgets/login_field.dart';
import 'package:shop_proh/features/auth/widgets/social_button.dart';
import 'package:shop_proh/features/cart/widgets/palete.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void navigateToRegister() {
    Navigator.of(context).pushNamed(RegisterScreen.routeName);
  }

  void signIn() {
    authService.signIn(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
  void navigateToForgotPassword() {
    Navigator.of(context).pushNamed(ForgotPasswordScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/signin_balls.png'),
              const Text(
                'Đăng nhập',
                style: TextStyle(
                  color: Pallete.gradient1,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 40),
              const SocialButton(
                  iconPath: 'assets/svgs/g_logo.svg',
                  label: 'Đăng nhập với Google',
                  horizontalPadding: 88),
              const SizedBox(height: 20),
              const SocialButton(
                iconPath: 'assets/svgs/f_logo.svg',
                label: 'Đăng nhập với Facebook',
                horizontalPadding: 80,
              ),
              const SizedBox(height: 15),
              const Text(
                'or',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 15),
              LoginField(hintText: 'Email', controller: _emailController),
              const SizedBox(height: 15),
              LoginField(
                hintText: 'Mật khẩu',
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              GradientButton(text: 'Đăng nhập', onPressed: signIn),
              const SizedBox(height: 20),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bạn quên mật khẩu?',
                  style: TextStyle(
                    color: Pallete.whiteColor,
                    fontSize: 17,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Thêm hàm xử lý khi người dùng nhấn vào nút "Quên mật khẩu" ở đây
                    navigateToForgotPassword();
                  },
                  child: const Text(
                    'Quên mật khẩu',
                    style: TextStyle(
                      color: Pallete.gradient1,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bạn chưa có tài khoản?',
                    style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 17,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      navigateToRegister();
                    },
                    child: const Text(
                      'Đăng ký',
                      style: TextStyle(
                        color: Pallete.gradient1,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
