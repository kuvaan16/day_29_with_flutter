import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_29_with_flutter/extentions.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';

import 'auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  bool error = false;
  bool login = true;
  int current = 1;
  double selectorPositionX = 20.0;
  double width1 = 36.0;
  double width2 = 53.0;
  double currentwidth = 34.0;
  GlobalKey _key1 = GlobalKey();
  GlobalKey _key2 = GlobalKey();
  _selectedItem(int id) {
    current = id;
    GlobalKey selectedGlobalKey = GlobalKey();
    double currentwidth = width1;
    switch (id) {
      case 1:
        selectedGlobalKey = _key1;

        break;
      case 2:
        selectedGlobalKey = _key2;

        break;
      default:
    }
    _setWidgetPositionX(selectedGlobalKey);
    setState(() {});
  }

  _setWidgetPositionX(GlobalKey selectedKey) {
    final RenderBox widgetRenderBox =
        selectedKey.currentContext!.findRenderObject() as RenderBox;
    final widgetPosition = widgetRenderBox.localToGlobal(Offset.zero);
    selectorPositionX = widgetPosition.dx;
  }

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passController.text.trim(),
    );
  }

  Future signUp() async {
    try {
      if (passwordConfirmed()) {
        _firestore.collection('friends').add({
          'email': emailController.text.trim(),
          'username': userNameController.text.trim(),
        });
        final newUser = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim(),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Auth(),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  bool passwordConfirmed() {
    if (passController.text.trim() == confirmPasswordController.text.trim()) {
      return true;
    } else {
      setState(() {
        error = true;
        emailController.clear();
        passController.clear();
        confirmPasswordController.clear();
      });

      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _setWidgetPositionX(_key1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: "#e9edf8".toColor(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                ),
                Positioned(
                  top: -50,
                  left: -40,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, -3),
                          color: Color.fromARGB(92, 0, 0, 0),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -90,
                  right: -70,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(250),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, -3),
                          color: Color.fromARGB(92, 0, 0, 0),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, bottom: 12),
                      child: Row(
                        children: [
                          InkWell(
                            key: _key1,
                            onTap: () {
                              _selectedItem(1);
                              setState(() {
                                
                                login = true;
                                error = false;
                                emailController.clear();
                                passController.clear();
                                confirmPasswordController.clear();
                              });
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: current == 1
                                    ? Colors.deepPurpleAccent
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          InkWell(
                            key: _key2,
                            onTap: () {
                              _selectedItem(2);
                              setState(() {
                                
                                login = false;
                                emailController.clear();
                                passController.clear();
                                confirmPasswordController.clear();
                              });
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: current == 2
                                    ? Colors.deepPurpleAccent
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      left: selectorPositionX,
                      bottom: 4,
                      child: Container(
                        width: currentwidth,
                        height: 2,
                        decoration: ShapeDecoration(
                          shape: StadiumBorder(),
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    )
                  ],
                ),
                textFild(
                    "Email",
                    Icon(
                      Ionicons.mail_outline,
                      size: 20,
                    ),
                    emailController,
                    false),
                login
                    ? Text("")
                    : textFild(
                        "Username",
                        Icon(
                          Ionicons.person_outline,
                          size: 20,
                        ),
                        userNameController,
                        false),
                textFild(
                    "Password",
                    Icon(
                      Ionicons.lock_closed_outline,
                      size: 20,
                    ),
                    passController,
                    true),
                login
                    ? Text("")
                    : textFild(
                        "Confirm Password",
                        Icon(
                          Ionicons.lock_closed_outline,
                          size: 20,
                        ),
                        confirmPasswordController,
                        true),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 30, top: 10),
                    child: Text(
                      error ? "Passwords are not the same !" : "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                      ),
                    )),
                GestureDetector(
                  onTap: login ? signIn : signUp,
                  child: Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                      margin: EdgeInsets.only(
                          left: 50, right: 50, top: 10, bottom: 0),
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(158, 158, 158, 158),
                                blurRadius: 25,
                                offset: Offset(0, 5),
                                spreadRadius: 1),
                          ]),
                      child: Text(
                        login ? "Login" : "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: login ? 229 : 123,
                ),
                Positioned(
                  left: 70,
                  bottom: 60,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 5),
                          color: Color.fromARGB(40, 0, 0, 0),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -30,
                  child: Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(250),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 5),
                          color: Color.fromARGB(40, 0, 0, 0),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget textFild(
    String title, Icon icon, TextEditingController controller, bool val) {
  return Container(
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 255, 255, 255),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          blurRadius: 25,
          color: Color.fromARGB(58, 158, 158, 158),
          offset: Offset(0, 8),
          spreadRadius: 1,
        ),
      ],
    ),
    margin: EdgeInsets.only(left: 30, right: 30, top: 10),
    child: TextField(
      obscureText: val ? true : false,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        hintText: title,
        hintStyle: TextStyle(color: Colors.deepPurpleAccent, fontSize: 14),
        prefixIconColor: Colors.deepPurpleAccent,
        prefixIcon: icon,
      ),
    ),
  );
}
