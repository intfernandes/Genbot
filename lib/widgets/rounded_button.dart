import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color? buttonColor;
  final String title;
  final void Function()?  onTap;
  final bool loading;
  const RoundedButton({super.key, required this.title, this.onTap,  this.loading = false, this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: loading? CircularProgressIndicator(strokeWidth: 3 , color: Colors.white,): Text(title , style: TextStyle(fontSize: 16, color: Colors.white),)),
      ),
    );
  }
}
