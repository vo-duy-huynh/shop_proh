import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_proh/features/account/widgets/account_button.dart';
import 'package:shop_proh/features/auth/services/auth_service.dart';
import 'package:shop_proh/providers/theme_provider.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
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
              text: 'Cập Nhật Thông Tin',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
              text: Provider.of<ThemeProvider>(context).isDark
                  ? 'Chế Độ Sáng'
                  : 'Chế Độ Tối',
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
            AccountButton(
              text: 'Đăng Xuất',
              onTap: () {
                AuthService().logOut(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
