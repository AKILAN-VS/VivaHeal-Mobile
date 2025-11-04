import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivatest/screens/dash_navigator.dart';
import 'package:vivatest/screens/forgot_password.dart';
import 'package:vivatest/utils/buttons.dart';
import 'package:vivatest/utils/login_colors.dart';
import 'package:vivatest/utils/login_images.dart';
import 'package:vivatest/utils/login_strings.dart';
import 'package:vivatest/utils/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isVisible = false;
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  bool isKeepMeSignedIn = false;
  bool isLoading = false;

  LoginPageColors colorObj = LoginPageColors();
  LoginPageStrings stringObj = LoginPageStrings();

  String? emailErrorMessage;
  String? passwordErrorMessage;

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() => setState(() {}));
    passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    emailController.dispose();
    passwordFocusNode.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Color get emailBorderColor =>
      emailFocusNode.hasFocus ? colorObj.tealColor : colorObj.textGreyColor;

  Color get passwordBorderColor =>
      passwordFocusNode.hasFocus ? colorObj.tealColor : colorObj.textGreyColor;

  bool validateAllFields() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    bool isValid = true;

    setState(() {
      emailErrorMessage = email.isEmpty
          ? "Email cannot be empty"
          : (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)
                ? "Enter a valid email address"
                : null);
      if (emailErrorMessage != null) isValid = false;

      passwordErrorMessage = password.isEmpty
          ? stringObj.passwordEmptyError
          : (password.length < 6
                ? stringObj.passwordEmptyError
                : (!RegExp(r'[A-Z]').hasMatch(password)
                      ? stringObj.passwordNoUpperCaseError
                      : (!RegExp(r'[0-9]').hasMatch(password)
                            ? stringObj.passwordNoNumberError
                            : (!RegExp(
                                    r'[!@#\$&*~%^()_+\-=\[\]{};:\\|,.<>\/?]',
                                  ).hasMatch(password)
                                  ? stringObj.passwordNoSpecialCharacterError
                                  : null))));

      if (passwordErrorMessage != null) isValid = false;
    });

    return isValid;
  }

  Future<void> loginWithEmail() async {
    String email = emailController.text.trim();
    String password = passwordController.text;

    setState(() => isLoading = true); // ⏳ start loading

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid == null) throw Exception("User UID not found");

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Patients')
          .doc(uid)
          .get();

      if (!userDoc.exists) throw Exception("User data not found in Firestore");

      final userData = userDoc.data() as Map<String, dynamic>;

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(onLog: true, patientData: userData),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg;
      if (e.code == 'user-not-found') {
        errorMsg = "No user found with this email";
      } else if (e.code == 'wrong-password') {
        errorMsg = "Incorrect password";
      } else {
        errorMsg = e.message ?? "Login failed";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      if (mounted) setState(() => isLoading = false); // ✅ stop loading
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    bool dev = screenSize.width < 600;
    bool isLoggedIn = false;

    return Scaffold(
      backgroundColor: colorObj.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 24, 24, keyboardHeight + 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/vivaheallogo.png',
                      width: dev ? 180 : 180,
                      height: dev ? 180 : 180,
                    ),
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenSize.height * 0.01),
                        // Image.asset(
                        //   'assets/vivaheallogo.png',
                        //   width: dev ? 120 : 180,
                        //   height: dev ? 120 : 180,
                        // ),
                        Text(
                          stringObj.loginText,
                          style: TextStyles.monText(
                            fontSize: dev ? 45 : 60,
                            fontWeight: FontWeight.w600,
                            color: colorObj.textDarkColor,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email Field
                        Row(
                          children: [
                            Text(
                              stringObj.emailHead,
                              style: TextStyles.monText(
                                fontSize: dev ? 12 : 18,
                                fontWeight: FontWeight.w500,
                                color: colorObj.textDarkColor,
                              ),
                            ),
                            Text(
                              " *",
                              style: TextStyles.monText(
                                fontSize: dev ? 12 : 18,
                                fontWeight: FontWeight.w500,
                                color: colorObj.errorColorRed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: dev ? 44 : 62,
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: colorObj.backgroundColor,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: colorObj.shadowBlack,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border(
                              bottom: BorderSide(
                                color: emailBorderColor,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: TextField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyles.monText(
                              fontSize: dev ? 14 : 20,
                              fontWeight: FontWeight.w600,
                              color: colorObj.textDarkColor,
                            ),
                            decoration: InputDecoration(
                              hintText: " " + stringObj.emailPlaceHolder,
                              hintStyle: TextStyles.monText(
                                fontSize: dev ? 11 : 19,
                                fontWeight: FontWeight.w400,
                                color: colorObj.textGreyColor,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        if (emailErrorMessage != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              emailErrorMessage!,
                              style: TextStyle(
                                color: colorObj.errorColorRed,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Password Field
                        Row(
                          children: [
                            Text(
                              stringObj.passwordHead,
                              style: TextStyles.monText(
                                fontSize: dev ? 12 : 18,
                                fontWeight: FontWeight.w500,
                                color: colorObj.textDarkColor,
                              ),
                            ),
                            Text(
                              " *",
                              style: TextStyles.monText(
                                fontSize: dev ? 12 : 18,
                                fontWeight: FontWeight.w500,
                                color: colorObj.errorColorRed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: dev ? 44 : 62,
                          padding: const EdgeInsets.only(left: 8, right: 1),
                          decoration: BoxDecoration(
                            color: colorObj.backgroundColor,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: colorObj.shadowBlack,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border(
                              bottom: BorderSide(
                                color: passwordBorderColor,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: TextField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            obscureText: !isVisible,
                            style: TextStyles.monText(
                              fontSize: dev ? 14 : 20,
                              fontWeight: FontWeight.w500,
                              color: colorObj.textDarkColor,
                            ),
                            decoration: InputDecoration(
                              hintText: stringObj.passwordPlaceHolder,
                              hintStyle: TextStyles.monText(
                                fontSize: dev ? 11 : 19,
                                fontWeight: FontWeight.w400,
                                color: colorObj.textGreyColor,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                child: Icon(
                                  isVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: dev ? 22 : 28,
                                  color: colorObj.textGreyColor,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        if (passwordErrorMessage != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              passwordErrorMessage!,
                              style: TextStyle(
                                color: colorObj.errorColorRed,
                                fontSize: 13,
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isKeepMeSignedIn = !isKeepMeSignedIn;
                                });
                              },
                              icon: Icon(
                                Icons.check_circle_outline_outlined,
                                color: isKeepMeSignedIn
                                    ? Colors.teal
                                    : colorObj.textGreyColor,
                                size: 23,
                              ),
                            ),
                            Text(
                              stringObj.keepMeSignedIn,
                              style: TextStyles.monText(
                                fontSize: dev ? 14 : 20,
                                fontWeight: FontWeight.w600,
                                color: colorObj.textDarkColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Center(
                          child: gradientButton(
                            buttonLabel: isLoading
                                ? "Logging in..."
                                : stringObj.loginButton,
                            onPressed: () {
                              if (!isLoading && validateAllFields()) {
                                loginWithEmail();
                              }
                            },
                            height: screenSize.height,
                            width: screenSize.width,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPassword(),
                                ),
                              );
                            },
                            child: Text(
                              stringObj.forgotPasswordButton,
                              style: TextStyles.monText(
                                fontSize: dev ? 14 : 20,
                                fontWeight: FontWeight.w500,
                                color: colorObj.textGreyColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
