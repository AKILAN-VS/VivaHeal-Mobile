import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _openDialPad(String number) async {
    final Uri dialUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(dialUri)) {
      await launchUrl(dialUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open dial pad')));
    }
  }

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
    final String bloodGroup = data['bloodGroup'] ?? 'N/A';
    final String vivacardNumber = data['vivacardNumber'].toString();
    final String lastVisited = data['lastUpdatedDate'] ?? 'N/A';
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
                        'assets/profilepic.png',
                        width: 60,
                        height: 60,
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

              // Upcoming Appointments Section
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
                        "Upcoming Appointments",
                        style: TextStyles.monText(
                          fontSize: dev ? 20 : 26,
                          fontWeight: FontWeight.w600,
                          color: dashColors.textDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ✅ StreamBuilder showing only requested + confirmed
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('appointments')
                            .where(
                              'patientID',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                            )
                            .where(
                              'status',
                              whereIn: ['requested', 'upcoming', 'confirmed'],
                            )
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            debugPrint(
                              "❌ FIRESTORE ERROR DETAILS: ${snapshot.error}",
                            );
                            return Text(
                              "Error loading upcoming appointments",
                              style: TextStyles.monText(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            );
                          }

                          // ✅ Filter out completed or cancelled just in case
                          final allData = snapshot.data?.docs ?? [];
                          final data = allData.where((doc) {
                            final status = (doc['status'] ?? '')
                                .toString()
                                .toLowerCase();
                            final isCompleted = doc['isCompleted'] == true;
                            // Show if it's requested, confirmed, or upcoming, but not completed
                            return (status == 'requested' ||
                                    status == 'confirmed' ||
                                    status == 'upcoming') &&
                                !isCompleted;
                          }).toList();

                          if (data.isEmpty) {
                            return Text(
                              "No upcoming appointments",
                              style: TextStyles.monText(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: dashColors.textGreyColor,
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: data.map((doc) {
                              final appointment =
                                  doc.data() as Map<String, dynamic>;
                              final Timestamp? ts =
                                  appointment['appointmentDate'];
                              final String dateText = ts != null
                                  ? DateFormat(
                                      'MMM dd, yyyy • hh:mm a',
                                    ).format(ts.toDate())
                                  : 'No date set';
                              final String illness =
                                  appointment['illness'] ?? 'N/A';
                              final String status =
                                  (appointment['status'] ?? 'Unknown')
                                      .toString();
                              final String doctorID =
                                  appointment['doctorID'] ?? '';

                              Color statusColor;
                              switch (status.toLowerCase()) {
                                case 'confirmed':
                                  statusColor = Colors.green.shade600;
                                  break;
                                case 'requested':
                                  statusColor = Colors.orange.shade600;
                                  break;
                                case 'upcoming':
                                  statusColor = Colors.blue.shade600;
                                  break;
                                default:
                                  statusColor = Colors.grey.shade600;
                              }

                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(doctorID)
                                    .get(),
                                builder: (context, docSnap) {
                                  String doctorName = 'N/A';
                                  if (docSnap.hasData && docSnap.data!.exists) {
                                    final doctorData =
                                        docSnap.data!.data()
                                            as Map<String, dynamic>;
                                    doctorName = doctorData['name'] ?? 'N/A';
                                  }

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: dashColors.backgroundColorBlend,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          offset: const Offset(2, 3),
                                          blurRadius: 6,
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.15),
                                        width: 0.7,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 12,
                                          width: 12,
                                          margin: const EdgeInsets.only(
                                            top: 5,
                                            right: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Dr. $doctorName",
                                                style: TextStyles.monText(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      dashColors.textDarkColor,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                illness,
                                                style: TextStyles.monText(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      dashColors.textGreyColor,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                dateText,
                                                style: TextStyles.monText(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      dashColors.textGreyColor,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Status: $status",
                                                style: TextStyles.monText(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: statusColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Book Appointment + SOS
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
                        onPressed: () {
                          _openDialPad("108");
                        },
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
