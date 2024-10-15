import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyInputFieldController extends GetxController {
  bool isPasswordVisible = false;

  void toggleIsPassword() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }
}

class MyInputField extends StatelessWidget {
  final String label;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isPassword;

  const MyInputField({
    super.key,
    required this.label,
    required this.textController,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyInputFieldController>(
      init: MyInputFieldController(),
      builder: (controller) {
        return TextFormField(
          controller: textController,
          decoration: InputDecoration(
            labelText: label,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      controller.isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.toggleIsPassword,
                  )
                : null,
          ),
          validator: validator,
          keyboardType: keyboardType,
          obscureText: isPassword && !controller.isPasswordVisible,
        );
      },
    );
  }
}
