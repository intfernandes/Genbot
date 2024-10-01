import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genbot/constants/colors.dart';
import 'package:genbot/utils/toast_message.dart';
import 'package:genbot/widgets/my_textfeild.dart';
import 'package:genbot/widgets/rounded_button.dart';
import 'package:iconsax/iconsax.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onPressed;
  const RegisterScreen({super.key, this.onPressed});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  late bool isObsecure;
  late bool isConfirmObsecure;

  void register() {
    setState(() {
      loading = true;
    });
   if(passwordController.text.toString() == confirmPasswordController.text.toString()){
     _auth.createUserWithEmailAndPassword(
         email: emailController.text.toString(),
         password: passwordController.text.toString())
         .then((value) {
       Toasts().toastMessages("Account Created");
       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
       setState(() {
         loading = false;
       });
     })
         .onError((error, StackTrace) {
       Toasts().toastMessagesAlert(error.toString());
     });
   }else{
     Toasts().toastMessagesAlert("Passwords do not match!");
     setState(() {
       loading = false;
     });
   }
  }

  @override
  void initState() {
    super.initState();
    isObsecure = true;
    isConfirmObsecure = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFFFFFFFF), Color(0xFFbef0ff)])),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Create Account!",
                  style: TextStyle(
                      fontFamily: "Poppins Bold",
                      fontSize: 26,
                      color: Colours.darkBlue,),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Please enter valid information to access your account.",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      color: Colours.darkBlue,),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    // email
                    MyTextFeild(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false,
                      prefixIcon: (Iconsax.send_2),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // password
                    MyTextFeild(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: isObsecure,
                      prefixIcon: (Iconsax.password_check),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObsecure = !isObsecure;
                            });
                          },
                          icon: isObsecure
                              ? const Icon(Iconsax.eye)
                              : const Icon(Iconsax.eye_slash)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // confirm password
                    MyTextFeild(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      obscureText: isConfirmObsecure,
                      prefixIcon: (Iconsax.password_check),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isConfirmObsecure = !isConfirmObsecure;
                            });
                          },
                          icon: isConfirmObsecure
                              ? const Icon(Iconsax.eye)
                              : const Icon(Iconsax.eye_slash)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                //  Login Button
                RoundedButton(
                  title: "Register",
                  buttonColor: Colours.darkBlue,
                  loading: loading,
                  onTap: () {
                    register();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                          color:Colours.darkBlue, fontFamily: "Poppins"),
                    ),
                    TextButton(
                        onPressed: widget.onPressed,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Colours.darkBlue,
                              fontFamily: "Poppins Bold"),
                        ))
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
