import 'package:flutter/material.dart';
import 'package:shop_proh/features/account/screens/account_screen.dart';
import 'package:shop_proh/features/account/widgets/account_button.dart';
import 'package:shop_proh/features/auth/services/auth_service.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: 'Đơn Hàng',
              onTap: () {},
            ),
            AccountButton(
              text: 'Địa Chỉ',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
              text: 'Đăng Xuất',
              onTap: () {
                AuthService().logOut(context);
              },
            ),
            AccountButton(
              text: 'Yêu Thích',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
