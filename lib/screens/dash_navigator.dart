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

  @override
  void initState() {
    super.initState();
  }

  // ✅ Fixed onTabChanged — safe from setState/build conflicts
  void onTabChanged(int index) {
    if (mounted && index != selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            selectedIndex = index;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool dev = screenSize.width < 600;

    // ✅ Always ensure a valid logged-in user
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ✅ Use UID from Firebase — guarantees a valid path
    final String patientId = currentUser.uid;

    // ✅ Safely get patientData (if passed from login)
    final patientData = widget.patientData ?? {};

    // ✅ Define all pages here
    final List<Widget> pages = [
      Dash(patientData: patientData),
      HistoryPage(patientId: patientId),
      Uploads(patientId: patientId),
      Profile(patientData: patientData),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(
          screenSize.width,
          screenSize.height * min(0.08, 1.0),
        ),
        child: Stack(
          children: [
            Container(
              height: 100,
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

      // ✅ IndexedStack prevents reloading on every tab change
      body: IndexedStack(index: selectedIndex, children: pages),

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
