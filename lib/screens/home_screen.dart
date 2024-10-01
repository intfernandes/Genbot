// ignore_for_file: unused_import, prefer_final_fields

import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:genbot/constants/colors.dart';
import 'package:genbot/utils/toast_message.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  ChatUser currenUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
      id: "1", firstName: "GENBOT", profileImage: "assets/images/logo.png");

  void logOut() {
    _auth.signOut();
  }

  // Show Dialouge
  void showLogoutDialog(BuildContext context, Function logOut) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        child: Padding(
          // Add padding around the content
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),

              // Title Text
              const Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(
                  color: Colours.darkBlue,
                  fontFamily: "Poppins Bold",
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 20),

              // Divider for a clean look
              Divider(
                color: Colors.grey[300], // Light grey divider
                thickness: 1,
              ),

              const SizedBox(height: 10),

              // Row for buttons
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Space out buttons evenly
                children: [
                  // Cancel Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White background
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded button corners
                        side: const BorderSide(
                            color: Colours.darkBlue), // Border color
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colours.darkBlue,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  // Logout Button
                  ElevatedButton(
                    onPressed: () {
                      logOut(); // Call the logout function
                      Navigator.pop(context); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colours.darkBlue, // Dark blue background
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white, // White text for contrast
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "GENBOT",
              style: TextStyle(
                  color: Color(0xFF022c41),
                  fontFamily: "Poppins bold",
                  fontSize: 30),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showLogoutDialog(context, logOut);
                },
                icon: const Icon(Iconsax.logout4),
              )
            ],
            backgroundColor: Colors.transparent,
          ),
          body: Stack(children: [
            Center(
                child: Image.asset(
              "assets/images/logo.png",
              height: 200,
            )),
            _buildUI()
          ]),
        ));
  }

  Widget _buildUI() {
    return DashChat(
      messageOptions: const MessageOptions(
        currentUserContainerColor: Colours.darkBlue,
      ),
      currentUser: currenUser,
      onSend: _sendMessage,
      messages: messages,
      inputOptions: InputOptions(
          sendButtonBuilder: (void Function()? onSend) {
            return IconButton(
              icon: const Icon(Iconsax.send_2),
              onPressed: onSend,
            );
          },
          trailing: [
            IconButton(
                onPressed: _sendMediaMessage, icon: const Icon(Iconsax.gallery))
          ]),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }
      gemini.streamGenerateContent(question, images: images).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage messgae = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [messgae, ...messages];
          });
        }
      });
    } catch (e) {
      Toasts().toastMessagesAlert(e.toString());
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
          user: currenUser,
          createdAt: DateTime.now(),
          medias: [
            ChatMedia(url: file.path, fileName: "", type: MediaType.image)
          ]);
      _sendMessage(chatMessage);
    }
  }
}
