import 'package:flutter/material.dart';
import 'package:vivatest/screens/password_changed.dart';
import 'package:vivatest/utils/buttons.dart';
import 'package:vivatest/utils/login_colors.dart';
import 'package:vivatest/utils/login_strings.dart';
import 'package:vivatest/utils/text_styles.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isVisible = false;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  String? newPasswordErrorMessage;
  String? confirmPasswordErrorMessage;

  final LoginPageColors colorObj = LoginPageColors();
  final LoginPageStrings stringObj = LoginPageStrings();

  bool validateAllFields() {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    bool isValid = true;

    setState(() {
      newPasswordErrorMessage = newPassword.isEmpty
          ? stringObj.passwordEmptyError
          : (newPassword.length < 6
                ? stringObj.passwordEmptyError
                : (!RegExp(r'[A-Z]').hasMatch(newPassword)
                      ? stringObj.passwordNoUpperCaseError
                      : (!RegExp(r'[0-9]').hasMatch(newPassword)
                            ? stringObj.passwordNoNumberError
                            : (!RegExp(
                                    r'[!@#\$&*~%^()_+\-=\[\]{};:\\|,.<>\/?]',
                                  ).hasMatch(newPassword)
                                  ? stringObj.passwordNoSpecialCharacterError
                                  : null))));

      if (newPasswordErrorMessage != null) {
        isValid = false;
      }

      confirmPasswordErrorMessage = confirmPassword.isEmpty
          ? "Confirm password cannot be empty"
          : (confirmPassword != newPassword ? "Passwords do not match" : null);

      if (confirmPasswordErrorMessage != null) {
        isValid = false;
      }
    });

    return isValid;
  }

  Color get newPasswordBorderColor => newPasswordFocusNode.hasFocus
      ? colorObj.tealColor
      : colorObj.textGreyColor;

  Color get confirmPasswordBorderColor => confirmPasswordFocusNode.hasFocus
      ? colorObj.tealColor
      : colorObj.textGreyColor;

  @override
  void initState() {
    super.initState();
    newPasswordFocusNode.addListener(() {
      setState(() {});
    });
    confirmPasswordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    bool dev = screenSize.width < 600;

    return Scaffold(
      backgroundColor: colorObj.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 24, 24, keyboardHeight + 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenSize.height * 0.1),
                    Row(
                      children: [
                        Text(
                          stringObj.changePasswordHead,
                          style: TextStyles.monText(
                            fontSize: dev ? 36 : 51,
                            fontWeight: FontWeight.w600,
                            color: colorObj.textDarkColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),

                    // New Password Field Label
                    Row(
                      children: [
                        Text(
                          stringObj.newPasswordHead,
                          style: TextStyles.monText(
                            fontSize: dev ? 12 : 18,
                            fontWeight: FontWeight.w500,
                            color: colorObj.textDarkColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          stringObj.asteriks,
                          style: TextStyles.monText(
                            fontSize: dev ? 15 : 21,
                            fontWeight: FontWeight.w500,
                            color: colorObj.errorColorRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // New Password Input
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
                            color: newPasswordBorderColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: newPasswordController,
                        focusNode: newPasswordFocusNode,
                        obscureText: !isVisible,
                        style: TextStyles.monText(
                          fontSize: dev ? 14 : 20,
                          fontWeight: FontWeight.w500,
                          color: colorObj.textDarkColor,
                        ),
                        decoration: InputDecoration(
                          hintText: stringObj.newPasswordPlaceHolder,
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
                            horizontal: 6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (newPasswordErrorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          newPasswordErrorMessage!,
                          style: TextStyle(
                            color: colorObj.errorColorRed,
                            fontSize: 13,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Confirm Password Label
                    Row(
                      children: [
                        Text(
                          stringObj.confirmPasswordHead,
                          style: TextStyles.monText(
                            fontSize: dev ? 12 : 18,
                            fontWeight: FontWeight.w500,
                            color: colorObj.textDarkColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          stringObj.asteriks,
                          style: TextStyles.monText(
                            fontSize: dev ? 15 : 21,
                            fontWeight: FontWeight.w500,
                            color: colorObj.errorColorRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Confirm Password Input
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
                            color: confirmPasswordBorderColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        obscureText: !isVisible,
                        style: TextStyles.monText(
                          fontSize: dev ? 14 : 20,
                          fontWeight: FontWeight.w500,
                          color: colorObj.textDarkColor,
                        ),
                        decoration: InputDecoration(
                          hintText: stringObj.confirmPasswordPlaceHolder,
                          hintStyle: TextStyles.monText(
                            fontSize: dev ? 11 : 19,
                            fontWeight: FontWeight.w400,
                            color: colorObj.textGreyColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (confirmPasswordErrorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          confirmPasswordErrorMessage!,
                          style: TextStyle(
                            color: colorObj.errorColorRed,
                            fontSize: 13,
                          ),
                        ),
                      ),

                    const SizedBox(height: 30),

                    Center(
                      child: gradientButton(
                        buttonLabel: stringObj.changePasswordHead,
                        onPressed: () {
                          bool isValid = validateAllFields();
                          if (isValid) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const PasswordChangedScreen(); // Next screen
                                },
                              ),
                            );
                          }
                        },
                        height: screenSize.height,
                        width: screenSize.width,
                      ),
                    ),
                    const SizedBox(height: 20),
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
