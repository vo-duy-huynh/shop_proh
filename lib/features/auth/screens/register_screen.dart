import 'package:flutter/material.dart';
import 'package:shop_proh/features/auth/screens/auth_screen.dart';
import 'package:shop_proh/features/auth/services/auth_service.dart';
import 'package:shop_proh/features/auth/widgets/gradient_button.dart';
import 'package:shop_proh/features/auth/widgets/login_field.dart';
import 'package:shop_proh/features/cart/widgets/palete.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register-screen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void navigateToLogin() {
    Navigator.of(context).pushNamed(AuthScreen.routeName);
  }

  void signUp() {
    authService.signUp(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
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
                'Đăng Ký',
                style: TextStyle(
                  color: Pallete.gradient1,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 40),
              LoginField(
                  hintText: 'Tên người dùng', controller: _nameController),
              const SizedBox(height: 15),
              LoginField(hintText: 'Email', controller: _emailController),
              const SizedBox(height: 15),
              LoginField(hintText: 'Mật khẩu', controller: _passwordController),
              const SizedBox(height: 20),
              GradientButton(
                text: 'Đăng ký',
                onPressed: signUp,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bạn đã có tài khoản?',
                    style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 17,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AuthScreen.routeName);
                    },
                    child: const Text(
                      'Đăng nhập',
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
