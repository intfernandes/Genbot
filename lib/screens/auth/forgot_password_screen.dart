import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genbot/constants/colors.dart';
import 'package:genbot/utils/toast_message.dart';
import 'package:genbot/widgets/my_textfeild.dart';
import 'package:genbot/widgets/rounded_button.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  void forgotPassword(){
    setState(() {
      loading = true;
    });
    _auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
      Toasts().toastMessages("Password reset email sent successfully!");
      setState(() {
        loading = false;
      });
    }).onError((error, StackTrace){
      Toasts().toastMessagesAlert(error.toString());
      setState(() {
        loading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xFFFFFFFF), Color(0xFFbef0ff)])
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Forgot Password", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700 ,color: Colours.darkBlue,),),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              const SizedBox(height: 50,),
              MyTextFeild(
                controller: emailController,
                hintText: "Enter Email", 
                obscureText: false, 
                prefixIcon: Iconsax.send_2,
                ),
                const SizedBox(height: 20,),
                RoundedButton(
                  title: "Forgot Password", 
                  buttonColor: Colours.darkBlue,
                  loading: loading,
                  onTap: forgotPassword,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}