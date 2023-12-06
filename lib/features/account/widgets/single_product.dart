import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_proh/providers/user_provider.dart';

class SingleProduct extends StatelessWidget {
  final String image;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SingleProduct({
    Key? key,
    required this.image,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Container(
              width: 180,
              padding: const EdgeInsets.all(10),
              child: Image.network(
                image,
                fit: BoxFit.fitHeight,
                width: 180,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.black12,
                  width: 1.5,
                ),
              ),
              // nếu là admin thì hiển thị nút xóa
              child: user.type == 'admin'
                  ? IconButton(
                      icon: const Icon(Icons.delete_outline),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(0),
                        ),
                        iconSize: MaterialStateProperty.all(20),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: onDelete,
                    )
                  : const SizedBox(),
            ),
          ),
          user.type == 'admin'
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black12,
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(0),
                        ),
                        iconSize: MaterialStateProperty.all(20),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow),
                      ),
                      onPressed: onEdit,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
