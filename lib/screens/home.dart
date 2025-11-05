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
  final Map<String, dynamic> patientData;

  const Dash({Key? key, required this.patientData}) : super(key: key);

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  DashboardStrings dashStrings = DashboardStrings();
  DashboardColors dashColors = DashboardColors();
  late Map<String, dynamic> data;
  bool showCancelled = false;
  String? patientName;

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
    data = widget.patientData;
    patientName = data['name'] ?? 'Unknown';
  }

  Future<void> _confirmCancel(String appointmentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Appointment"),
        content: const Text(
          "Are you sure you want to cancel this appointment?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _cancelAppointment(appointmentId);
    }
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({
            'status': 'cancelled',
            'cancelledBy': patientName ?? 'Unknown',
            'cancelledAt': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment cancelled successfully'),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel appointment: $e')),
      );
    }
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
            children: [
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
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),
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
                            return Text(
                              "Error loading appointments",
                              style: TextStyles.monText(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            );
                          }

                          final allData = snapshot.data?.docs ?? [];
                          if (allData.isEmpty) {
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
                            children: allData.map((doc) {
                              final appt = doc.data() as Map<String, dynamic>;
                              final ts = appt['appointmentDate'] as Timestamp?;
                              final dateText = ts != null
                                  ? DateFormat(
                                      'MMM dd, yyyy • hh:mm a',
                                    ).format(ts.toDate())
                                  : 'No date';
                              final illness = appt['illness'] ?? 'N/A';
                              final status = appt['status'] ?? 'Unknown';
                              final doctorID = appt['doctorID'] ?? '';

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
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: dashColors.backgroundColorBlend,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Dr. $doctorName",
                                          style: TextStyles.monText(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: dashColors.textDarkColor,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          "Illness: $illness",
                                          style: TextStyles.monText(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: dashColors.textGreyColor,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          "Date: $dateText",
                                          style: TextStyles.monText(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w400,
                                            color: dashColors.textGreyColor,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          "Status: $status",
                                          style: TextStyles.monText(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton.icon(
                                            onPressed: () =>
                                                _confirmCancel(doc.id),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            label: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
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

                      const SizedBox(height: 12),
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              showCancelled = !showCancelled;
                            });
                          },
                          icon: Icon(
                            showCancelled
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: dashColors.textDarkColor,
                          ),
                          label: Text(
                            showCancelled
                                ? "Hide Cancelled Appointments"
                                : "Show Cancelled Appointments",
                            style: TextStyles.monText(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: dashColors.textDarkColor,
                            ),
                          ),
                        ),
                      ),

                      if (showCancelled)
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('appointments')
                              .where(
                                'patientID',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid,
                              )
                              .where('status', isEqualTo: 'cancelled')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final cancelled = snapshot.data?.docs ?? [];

                            if (cancelled.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  "No cancelled appointments",
                                  style: TextStyles.monText(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: dashColors.textGreyColor,
                                  ),
                                ),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: cancelled.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                final ts =
                                    data['appointmentDate'] as Timestamp?;
                                final dateText = ts != null
                                    ? DateFormat(
                                        'MMM dd, yyyy • hh:mm a',
                                      ).format(ts.toDate())
                                    : 'No date';
                                final illness = data['illness'] ?? 'N/A';
                                final cancelledBy =
                                    data['cancelledBy'] ?? 'Unknown';

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date: $dateText",
                                        style: TextStyles.monText(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: dashColors.textDarkColor,
                                        ),
                                      ),
                                      Text(
                                        "Illness: $illness",
                                        style: TextStyles.monText(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: dashColors.textGreyColor,
                                        ),
                                      ),
                                      Text(
                                        "Cancelled by: ${cancelledBy == patientName ? 'You' : cancelledBy}",
                                        style: TextStyles.monText(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
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
                        onPressed: () => _openDialPad("108"),
                        height: 40,
                        width: double.infinity,
                        cfontsize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
