import 'package:flutter/material.dart';
import 'package:vivatest/screens/book_appointment.dart';
import 'package:vivatest/utils/buttons.dart';
import 'package:vivatest/utils/dashboard_colors.dart';
import 'package:vivatest/utils/dashboard_strings.dart';
import 'package:vivatest/utils/text_styles.dart';

class Dash extends StatefulWidget {
  final Map<String, dynamic> patientData; // Receive full patient data

  const Dash({Key? key, required this.patientData}) : super(key: key);

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  DashboardStrings dashStrings = DashboardStrings();
  DashboardColors dashColors = DashboardColors();

  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = widget.patientData; // Already have patient data
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool dev = screenSize.width < 600;
    double paddingSize = dev ? 20.0 : 26.0;

    final String name = data['name'] ?? 'Patient Name';
    final int age = data['age'] ?? 0;
    final String gender = data['gender'] ?? 'Not Specified';
    final String bloodGroup = data['blood_group'] ?? 'N/A';
    final String vivacardNumber = data['vivacard_number'].toString();
    final String lastVisited = "2 weeks ago"; // Can calculate dynamically
    final List<String> activeTreatments = data['active_treatments'] != null
        ? List<String>.from(data['active_treatments'])
        : ["No active treatments"];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(paddingSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Section
              Container(
                height: 120,
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
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/woman.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyles.monText(
                              fontSize: dev ? 20 : 26,
                              fontWeight: FontWeight.w600,
                              color: dashColors.textDarkColor,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "$age Years, ",
                                style: TextStyles.monText(
                                  fontSize: dev ? 14 : 20,
                                  fontWeight: FontWeight.w500,
                                  color: dashColors.textGreyColor,
                                ),
                              ),
                              Text(
                                gender,
                                style: TextStyles.monText(
                                  fontSize: dev ? 14 : 20,
                                  fontWeight: FontWeight.w500,
                                  color: dashColors.textGreyColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Blood Group: ",
                                style: TextStyles.monText(
                                  fontSize: dev ? 14 : 20,
                                  fontWeight: FontWeight.w500,
                                  color: dashColors.textGreyColor,
                                ),
                              ),
                              Text(
                                bloodGroup,
                                style: TextStyles.monText(
                                  fontSize: dev ? 14 : 20,
                                  fontWeight: FontWeight.w500,
                                  color: dashColors.textGreyColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Last Visited: ",
                                style: TextStyles.monText(
                                  fontSize: dev ? 13 : 18,
                                  fontWeight: FontWeight.w500,
                                  color: dashColors.textGreyColor,
                                ),
                              ),
                              Text(
                                lastVisited,
                                style: TextStyles.monText(
                                  fontSize: dev ? 13 : 18,
                                  fontWeight: FontWeight.w500,
                                  color: dashColors.textGreyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Active Treatments Section
              Container(
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Active Treatments",
                        style: TextStyles.monText(
                          fontSize: dev ? 20 : 26,
                          fontWeight: FontWeight.w600,
                          color: dashColors.textDarkColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ...activeTreatments.map(
                        (treatment) => Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            treatment,
                            style: TextStyles.monText(
                              fontSize: dev ? 14 : 20,
                              fontWeight: FontWeight.w500,
                              color: dashColors.textGreyColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: dashColors.backgroundColorBlend,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "View More",
                                  style: TextStyles.monText(
                                    fontSize: dev ? 14 : 20,
                                    fontWeight: FontWeight.w500,
                                    color: dashColors.textDarkColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_double_arrow_down,
                                  color: dashColors.textDarkColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Book Appointment + SOS buttons
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: gradientButton(
                        buttonLabel: 'Book Appointment',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BookAppointmentPage(),
                            ),
                          );
                        },
                        height: 40,
                        width: double.infinity,
                        cfontsize: 11.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SOSButton(
                        buttonLabel: 'SOS',
                        onPressed: () {},
                        height: 40,
                        width: double.infinity,
                        cfontsize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
