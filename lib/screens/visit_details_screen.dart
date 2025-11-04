import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vivatest/utils/text_styles.dart'; 

class VisitDetailsScreen extends StatelessWidget {
  final String patientId;
  final String visitId;

  const VisitDetailsScreen({
    Key? key,
    required this.patientId,
    required this.visitId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Visit Details',
          style: TextStyles.monText(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0, 
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('history')
            .doc(patientId)
            .collection('visits')
            .doc(visitId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return Center(
              child: Text(
                "Could not load visit details.",
                style: TextStyles.monText(),
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final reason = data['reason'] ?? 'N/A';
          final notes = data['notes'] ?? 'No notes provided.';
          final medications = data['medications'] as List<dynamic>? ?? [];
          final reports = data['reports'] as List<dynamic>? ?? [];

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildDetailCard(
                context,
                title: 'Diagnosis',
                content: reason,
                icon: Icons.sick_outlined,
              ),
              _buildDetailCard(
                context,
                title: 'Doctor\'s Recommendations',
                content: notes,
                icon: Icons.notes_outlined,
              ),

              if (medications.isNotEmpty) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    'Prescribed Medications',
                    style: TextStyles.monText(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...medications.map(
                  (med) => Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.medication_outlined),
                      title: Text(
                        med['medication'] ?? 'Unknown Medication',
                        style: TextStyles.monText(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Dosage: ${med['dosage']} | Frequency: ${med['frequency']} | Duration: ${med['duration']}',
                        style: TextStyles.monText(),
                      ),
                    ),
                  ),
                ),
              ],

              if (reports.isNotEmpty) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    'Prescribed Reports',
                    style: TextStyles.monText(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...reports.map(
                  (report) => Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.science_outlined),
                      title: Text(
                        report['reportType'] ?? 'Unknown Report',
                        style: TextStyles.monText(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        report['details'] ?? 'No details.',
                        style: TextStyles.monText(),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyles.monText(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              content,
              style: TextStyles.monText(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
