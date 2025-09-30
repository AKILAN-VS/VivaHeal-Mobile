import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vivatest/screens/change_password.dart';
import 'package:vivatest/utils/buttons.dart';
import 'package:vivatest/utils/login_colors.dart';
import 'package:vivatest/utils/login_strings.dart';
import 'package:vivatest/utils/text_styles.dart';

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  bool verifyOTP = true; // Simulating OTP verification success

  LoginPageStrings stringObj = LoginPageStrings();
  LoginPageColors colorObj = LoginPageColors();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool dev = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                stringObj.forgotText,
                textAlign: TextAlign.center,
                style: TextStyles.monText(
                  fontSize: dev ? 38 : 53,
                  fontWeight: FontWeight.w600,
                  color: colorObj.textDarkColor,
                ),
              ),
              const SizedBox(height: 60),
              Text(
                'Enter the OTP sent to your number:',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              const SizedBox(height: 20),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: otpController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 8),
                  fieldHeight: 40,
                  fieldWidth: 35,
                  activeFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  activeColor: Colors.blue,
                  selectedColor: Colors.blueAccent,
                  inactiveColor: Colors.grey,
                ),
                enableActiveFill: true,
                onChanged: (value) {},
              ),
              const SizedBox(height: 30),
              gradientButton(
                height: 50,
                width: screenSize.width * 0.5,
                buttonLabel: 'Verify OTP',
                onPressed: () {
                  bool isValid = otpController.text.length == 6;
                  if (isValid) {
                    if (verifyOTP) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePassword(),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid 6-digit OTP'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
