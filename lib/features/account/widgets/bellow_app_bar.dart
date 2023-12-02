import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_proh/constants/globalvariable.dart';
import 'package:shop_proh/providers/user_provider.dart';

class BellowAppBar extends StatelessWidget {
  const BellowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Container(
      decoration: const BoxDecoration(
        gradient: GlobalVariables.appBarGradient,
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: [
          RichText(
              text: TextSpan(
            children: [
              TextSpan(
                text: 'Hello, ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
                children: [
                  TextSpan(
                    text: user.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}
