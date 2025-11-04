import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vivatest/screens/login_screen.dart';
import 'package:vivatest/utils/dashboard_colors.dart';
import 'package:vivatest/utils/dashboard_strings.dart';
import 'package:vivatest/utils/text_styles.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  final Map<String, dynamic>? patientData; // Nullable to avoid errors

  const Profile({Key? key, this.patientData}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DashboardStrings dashStrings = DashboardStrings();
  DashboardColors dashColors = DashboardColors();
  bool isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool dev = screenSize.width < 600;

    // Safely fallback to empty map if null
    final data = widget.patientData ?? {};
    final Timestamp? timestamp = data['lastUpdated'];
    final String formattedDate = timestamp != null
        ? DateFormat('dd/MM/yyyy').format(timestamp.toDate())
        : 'Not available';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // Profile Header
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: dashColors.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: dashColors.shadowBlack,
                      offset: const Offset(6, 6),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/profilepic.png', // Replace with your placeholder
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data['name'] ?? 'Unknown',
                      style: TextStyles.monText(
                        fontSize: dev ? 20 : 26,
                        fontWeight: FontWeight.w600,
                        color: dashColors.textDarkColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Patient ID: ${data['vivaCardNumber'] ?? 'N/A'}",
                      style: TextStyles.monText(
                        fontSize: dev ? 16 : 22,
                        fontWeight: FontWeight.w500,
                        color: dashColors.textGreyColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      // "Last Updated: ${data['lastUpdated'] ?? 'Not available'}",
                      "Last Updated: $formattedDate",
                      style: TextStyles.monText(
                        fontSize: dev ? 14 : 18,
                        fontWeight: FontWeight.w500,
                        color: dashColors.textGreyColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Medical History Section
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: dashColors.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: dashColors.shadowBlack,
                      offset: const Offset(6, 6),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "Medical History",
                        style: TextStyles.monText(
                          fontSize: dev ? 20 : 26,
                          fontWeight: FontWeight.w600,
                          color: dashColors.textDarkColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 62,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: dashColors.shadowBlack,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: dashColors.shadowBlack,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.mail,
                                    color: dashColors.textDarkColor,
                                    size: dev ? 20 : 26,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email",
                                    style: TextStyles.monText(
                                      fontSize: dev ? 16 : 22,
                                      fontWeight: FontWeight.w500,
                                      color: dashColors.textDarkColor,
                                    ),
                                  ),
                                  Text(
                                    data['email'] ?? 'Not available',
                                    style: TextStyles.monText(
                                      fontSize: dev ? 14 : 20,
                                      fontWeight: FontWeight.w500,
                                      color: dashColors.textGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Repeat for Phone
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 62,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: dashColors.shadowBlack,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: dashColors.shadowBlack,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.phone_outlined,
                                    color: dashColors.textDarkColor,
                                    size: dev ? 20 : 26,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone",
                                    style: TextStyles.monText(
                                      fontSize: dev ? 16 : 22,
                                      fontWeight: FontWeight.w500,
                                      color: dashColors.textDarkColor,
                                    ),
                                  ),
                                  Text(
                                    data['phone'] ?? 'Not available',
                                    style: TextStyles.monText(
                                      fontSize: dev ? 14 : 20,
                                      fontWeight: FontWeight.w500,
                                      color: dashColors.textGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: dashColors.shadowBlack,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                            bottom: 0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: dashColors.shadowBlack,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.pin_drop_outlined,
                                    color: dashColors.textDarkColor,
                                    size: dev ? 20 : 26,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Address",
                                      style: TextStyles.monText(
                                        fontSize: dev ? 16 : 22,
                                        fontWeight: FontWeight.w500,
                                        color: dashColors.textDarkColor,
                                      ),
                                    ),
                                    Text(
                                      data['address'] ?? 'Not available',
                                      style: TextStyles.monText(
                                        fontSize: dev ? 14 : 20,
                                        fontWeight: FontWeight.w500,
                                        color: dashColors.textGreyColor,
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Notifications Section
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: dashColors.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: dashColors.shadowBlack,
                      offset: const Offset(6, 6),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "Preferences",
                        style: TextStyles.monText(
                          fontSize: dev ? 20 : 26,
                          fontWeight: FontWeight.w600,
                          color: dashColors.textDarkColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 62,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: dashColors.shadowBlack,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Notifications",
                                    style: TextStyles.monText(
                                      fontSize: dev ? 16 : 22,
                                      fontWeight: FontWeight.w500,
                                      color: dashColors.textDarkColor,
                                    ),
                                  ),
                                  Text(
                                    "Enable/ Disable Notifications",
                                    style: TextStyles.monText(
                                      fontSize: dev ? 14 : 20,
                                      fontWeight: FontWeight.w500,
                                      color: dashColors.textGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isNotificationEnabled =
                                        !isNotificationEnabled;
                                  });
                                },
                                child: Icon(
                                  isNotificationEnabled
                                      ? Icons.toggle_on
                                      : Icons.toggle_off,
                                  color: isNotificationEnabled
                                      ? const Color.fromARGB(255, 13, 140, 125)
                                      : Colors.grey,
                                  size: dev ? 50 : 70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false, // clear all previous routes
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Logout failed: $e')),
                        );
                      }
                    },
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        color: dashColors.textDarkColor.withOpacity(0.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: dashColors.errorColorRed,
                              size: dev ? 20 : 26,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Logout",
                              style: TextStyles.monText(
                                fontSize: dev ? 14 : 20,
                                fontWeight: FontWeight.w700,
                                color: dashColors.errorColorRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
