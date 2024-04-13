import 'package:flutter/material.dart';

String uri = 'http://192.168.100.32:3000';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromRGBO(35, 114, 242, 1),
      Color.fromRGBO(35, 114, 242, 1),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;

  static const List<String> carouselImages = [
    'https://salework.net/wp-content/uploads/2022/09/kich-thuoc-anh-shopee-2.jpg',
    'https://intphcm.com/data/upload/banner-thoi-trang-dep.jpg',
    'https://thegioidohoa.com/wp-content/uploads/2018/12/thi%E1%BA%BFt-k%E1%BA%BF-banner-m%E1%BB%B9-ph%E1%BA%A9m-6.png',
    'https://img.lovepik.com/photo/45015/0532.jpg_wh860.jpg',
    'https://arena.fpt.edu.vn/wp-content/uploads/2022/10/bo-cuc-hinh-anh-an-tuong-thu-hut-anh-nhin-vao-trung-tam-cua-tam-banner-1.jpg',
  ];
}
