import 'package:flutter/material.dart';
import '../constants/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final double width;
  final EdgeInsetsGeometry? margin;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.width = double.infinity,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              child: Text(
                text,
                style: AppTextStyles.buttonText.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              child: Text(
                text,
                style: AppTextStyles.buttonText,
              ),
            ),
    );
  }
}
