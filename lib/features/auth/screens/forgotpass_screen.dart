import 'package:flutter/material.dart';
import 'package:shop_proh/features/auth/screens/auth_screen.dart';
import 'package:shop_proh/features/auth/screens/register_screen.dart';
import 'package:shop_proh/features/auth/services/auth_service.dart';
import 'package:shop_proh/features/auth/widgets/gradient_button.dart';
import 'package:shop_proh/features/auth/widgets/login_field.dart';
import 'package:shop_proh/features/auth/widgets/social_button.dart';
import 'package:shop_proh/features/cart/widgets/palete.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-screen';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void navigateToRegister() {
    Navigator.of(context).pushNamed(RegisterScreen.routeName);
  }

  void navigateToSignin() {
    Navigator.of(context).pushNamed(AuthScreen.routeName);
  }
  void sendMail() {
    authService.forGotPassword(
      context: context,
      email: _emailController.text,
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
                'Quên mật khẩu',
                style: TextStyle(
                  color: Pallete.gradient1,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(height: 15),
              LoginField(hintText: 'Email', controller: _emailController),
            
              const SizedBox(height: 20),
              GradientButton(text: 'Xác nhận', onPressed: sendMail),
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
                    // Thêm hàm xử lý khi người dùng nhấn vào nút "Quên mật khẩu" ở đây
                    navigateToSignin();
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
