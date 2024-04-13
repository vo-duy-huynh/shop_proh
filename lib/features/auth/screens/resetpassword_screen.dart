import 'package:flutter/material.dart';
import 'package:shop_proh/features/auth/screens/auth_screen.dart';
import 'package:shop_proh/features/auth/services/auth_service.dart';
import 'package:shop_proh/features/auth/widgets/gradient_button.dart';
import 'package:shop_proh/features/auth/widgets/login_field.dart';
import 'package:shop_proh/features/cart/widgets/palete.dart';

class ResetPassWordScreen extends StatefulWidget {
  static const String routeName = '/resetpass-screen';
  final String email;
  const ResetPassWordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPassWordScreen> createState() => _ResetPassWordScreenState();
}

class _ResetPassWordScreenState extends State<ResetPassWordScreen> {
  final AuthService authService = AuthService();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void resetPassWord() {
    if (_passwordController.text == _confirmPasswordController.text) {
      authService.resetPassWord(
        context: context,
        password: _passwordController.text,
        email: widget.email,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu không khớp'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                'Đặt lại mật khẩu',
                style: TextStyle(
                  color: Pallete.gradient1,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(height: 15),
              LoginField(
                hintText: 'Mật khẩu mới',
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 15),
              LoginField(
                  hintText: 'Nhập lại mật khẩu',
                  controller: _confirmPasswordController,
                  isPassword: true),
              const SizedBox(height: 20),
              GradientButton(
                text: 'Xác nhận',
                onPressed: resetPassWord,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
