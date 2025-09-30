import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vivatest/screens/history.dart';
import 'package:vivatest/screens/home.dart';
import 'package:vivatest/screens/profile.dart';
import 'package:vivatest/screens/uploads.dart';
import 'package:vivatest/utils/custom_bottom_bar.dart';
import 'package:vivatest/utils/dashboard_colors.dart';
import 'package:vivatest/utils/dashboard_strings.dart';
import 'package:vivatest/utils/text_styles.dart';

class Dashboard extends StatefulWidget {
  final bool onLog;
  final Map<String, dynamic>? patientData;

  const Dashboard({Key? key, required this.onLog, this.patientData})
    : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DashboardStrings dashStrings = DashboardStrings();
  DashboardColors dashColors = DashboardColors();
  int selectedIndex = 0;
  late bool onLog;
  Map<String, dynamic>? patientData;

  @override
  void initState() {
    super.initState();
    onLog = widget.onLog;
    patientData = widget.patientData;
  }

  // --- FIX IS HERE ---
  // This safely handles the initial state change after login.
  void onTabChanged(int index) {
    if (onLog) {
      // This schedules the state change to happen right after the build is complete.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectedIndex = 0;
          onLog = false; // Reset the flag
        });
      });
      return; // Exit early to avoid the second setState
    }

    // This handles all normal tab changes after the initial one.
    setState(() {
      selectedIndex = index;
    });
  }
  // --- END OF FIX ---

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool dev = screenSize.width < 600;

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final String patientId = currentUser.uid;

    final List<Widget> pages = [
      Dash(patientData: patientData ?? {}),
      HistoryPage(patientId: patientId),
      Uploads(),
      Profile(patientData: patientData ?? {}),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(dev ? kToolbarHeight : 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: dashColors.shadowBlack,
                    offset: const Offset(6, 6),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: AppBar(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text(
                    'VivaHeal',
                    style: TextStyles.monText(
                      fontSize: dev ? 20 : 26,
                      fontWeight: FontWeight.w600,
                      color: dashColors.textDarkColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: pages.length > selectedIndex ? pages[selectedIndex] : pages[0],
      bottomNavigationBar: CustomBottomBar(
        dashStrings: dashStrings,
        dashColors: dashColors,
        dev: dev,
        screenSize: screenSize,
        selectedIndex: selectedIndex,
        onTabChanged: onTabChanged,
      ),
    );
  }
}
