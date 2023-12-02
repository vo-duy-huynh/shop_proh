import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:shop_proh/common/widgets/custom_button.dart';
import 'package:shop_proh/common/widgets/custom_textfield.dart';
import 'package:shop_proh/constants/globalvariable.dart';
import 'package:shop_proh/constants/ultils.dart';
import 'package:shop_proh/features/address/services/address_services.dart';
import 'package:shop_proh/providers/user_provider.dart';
import 'package:shop_proh/payment_configuration.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({
    Key? key,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  String addressToBeUsed = "";
  bool isPressed = false;
  List<PaymentItem> paymentItems = [];
  final AddressServices addressServices = AddressServices();

  @override
  void initState() {
    super.initState();

    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Tổng tiền',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    addressController.dispose();
    nameController.dispose();
    phoneController.dispose();
    dateController.dispose();
  }

  void onApp(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      phoneNumber: phoneController.text,
      date: dateController.text,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void onGooglePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      phoneNumber: phoneController.text,
      date: dateController.text,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void payPressed(String addressFromProvider) {
    // Initialize the address to be used
    addressToBeUsed = "";
    bool isForm = addressController.text.isNotEmpty ||
        nameController.text.isNotEmpty ||
        phoneController.text.isNotEmpty ||
        dateController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed = addressController.text;
        isPressed = true;
      } else {
        isPressed = false;
        showSnackBar(context, 'Vui lòng nhập đầy đủ thông tin');
      }
    } else if (addressFromProvider.isNotEmpty && !isForm) {
      addressToBeUsed = addressFromProvider;
      showSnackBar(context, 'Vui lòng nhập đầy đủ thông tin');
      isPressed = false;
    } else {
      showSnackBar(context, 'Lỗi');
      isPressed = false;
    }
  }

  String os = Platform.operatingSystem;
  @override
  Widget build(BuildContext context) {
    // const String defaultApplePayConfigString = 'applepay.json';
    var address = context.watch<UserProvider>().user.address;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text('Đặt hàng'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Giao hàng đến: $address',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Hoặc nhập địa giao nhận hàng khác',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: addressController,
                      hintText: 'Nhập địa chỉ',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: nameController,
                      hintText: 'Nhập tên',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: phoneController,
                      hintText: 'Nhập số điện thoại',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: dateController,
                      hintText: 'Nhập ngày giao hàng',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              GooglePayButton(
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString(defaultGooglePay),
                paymentItems: paymentItems,
                type: GooglePayButtonType.pay,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (result) =>
                    debugPrint('Payment Result $result'),
                onPressed: () {
                  payPressed(address);
                  if (isPressed == true) {
                    onApp(context);
                  }
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  payPressed(address);
                  if (isPressed == true) {
                    onApp(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.yellow[700]!),
                  fixedSize: MaterialStateProperty.all(
                      const Size(double.infinity, 50)),
                  foregroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 247, 245, 245)),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                child: const Text('Thanh toán khi nhận hàng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
