// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genbot/constants/colors.dart';
import 'package:genbot/screens/auth/forgot_password_screen.dart';
import 'package:genbot/utils/toast_message.dart';
import 'package:genbot/widgets/my_textfeild.dart';
import 'package:genbot/widgets/rounded_button.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onPressed;
  const LoginScreen({super.key, required this.onPressed});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  late bool isObsecure;

  void login(){
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(
      email: emailController.text.toString(),
     password: passwordController.text.toString()).then((value){
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      Toasts().toastMessages("Login Sucessfull");
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
  void initState() {
    super.initState();
    isObsecure = true;
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
        appBar: AppBar(backgroundColor: Colors.transparent,),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/logo.png", height: 150,),
                const SizedBox(height: 10,),
                const Text("Welcome \n Back!", style: TextStyle(fontFamily: "Poppins Bold", fontSize: 26, color: Colours.darkBlue,),),
                const SizedBox(height: 10,),
                const Text("Enter your email address and password to get access to your account.", style: TextStyle(fontFamily: "Poppins", fontSize: 16, color: Color(0xFF022c41)),),
                const SizedBox(height: 20,),
                // email
               Column(
               children: [
                  MyTextFeild(
                 controller: emailController,
                 hintText: "Email", 
                 obscureText: false, 
                 prefixIcon:  (Iconsax.send_2),),
               const SizedBox(height: 20,),
               // password
               MyTextFeild(
                 controller: passwordController,
                 hintText: "Password",
                 obscureText: isObsecure,
                 prefixIcon:  (Iconsax.password_check),
                 suffixIcon: IconButton(
                 onPressed: (){
                   setState(() {
                     isObsecure =! isObsecure;
                   });
                 },
                 icon: isObsecure? const Icon( Iconsax.eye): const Icon(Iconsax.eye_slash)),),
                 const SizedBox(height: 10,),
               ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPasswordScreen()));
                }, child: Text("Forgot Password?", style: TextStyle(fontFamily: "Poppins Bold", color: Colours.darkBlue,),)),
              ),
              const SizedBox(height: 10,),
                  //  Login Button
                   RoundedButton(
                    title: "Login", 
                    buttonColor: Colours.darkBlue,
                    loading: loading, 
                    onTap: (){
                    login();
                   },)   ,
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const Text("Don't have an account?", style: TextStyle(color:Colours.darkBlue, fontFamily: "Poppins"),) ,
                        TextButton(
                          onPressed: widget.onPressed,
                         child: const Text("Register", style: TextStyle(color: Colours.darkBlue, fontFamily: "Poppins Bold"),)),
                    ],
                  )               
              ],
            ),
          ),
        ),
      ),
    );
  }
}