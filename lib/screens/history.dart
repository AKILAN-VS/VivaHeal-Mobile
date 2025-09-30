import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:vivatest/screens/visit_details_screen.dart'; // Make sure this import is correct
import 'package:vivatest/utils/text_styles.dart'; // Make sure this import is correct

class HistoryPage extends StatelessWidget {
  final String patientId;

  const HistoryPage({Key? key, required this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar has been removed.
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('history')
            .doc(patientId)
            .collection('visits')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyles.monText(),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No history found.", style: TextStyles.monText()),
            );
          }

          final allVisits = snapshot.data!.docs;
          final now = DateTime.now();

          final upcomingVisits = allVisits.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final date = data['date'] as Timestamp?;
            return date != null && date.toDate().isAfter(now);
          }).toList();

          final pastVisits = allVisits.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final date = data['date'] as Timestamp?;
            return date != null && !date.toDate().isAfter(now);
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (upcomingVisits.isNotEmpty) ...[
                Text(
                  "Upcoming Appointments",
                  style: TextStyles.monText(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...upcomingVisits.map(
                  (doc) => _buildVisitTile(context, doc, isUpcoming: true),
                ),
                const SizedBox(height: 24),
              ],

              if (pastVisits.isNotEmpty) ...[
                Text(
                  "Past Checkups",
                  style: TextStyles.monText(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...pastVisits.map(
                  (doc) => _buildVisitTile(context, doc, isUpcoming: false),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildVisitTile(
    BuildContext context,
    QueryDocumentSnapshot doc, {
    required bool isUpcoming,
  }) {
    final data = doc.data() as Map<String, dynamic>;
    final visitId = doc.id;
    final patientId = this.patientId;

    final visitDate = (data['date'] as Timestamp).toDate();
    final formattedDate = DateFormat('MMMM dd, yyyy').format(visitDate);
    final reason = data['reason'] ?? 'No reason provided';
    final doctorName = data['doctorName'] ?? 'N/A';

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(
          isUpcoming
              ? Icons.calendar_month_outlined
              : Icons.event_note_outlined,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          reason,
          style: TextStyles.monText(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "$doctorName\n$formattedDate",
          style: TextStyles.monText(),
        ),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    VisitDetailsScreen(patientId: patientId, visitId: visitId),
              ),
            );
          },
          child: Text(
            "View",
            style: TextStyles.monText(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
