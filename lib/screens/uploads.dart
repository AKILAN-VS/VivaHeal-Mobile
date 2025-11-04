import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivatest/utils/dashboard_colors.dart';
import 'package:vivatest/utils/text_styles.dart';

class Uploads extends StatefulWidget {
  final String patientId;

  const Uploads({Key? key, required this.patientId}) : super(key: key);

  @override
  State<Uploads> createState() => _UploadsState();
}

class _UploadsState extends State<Uploads> {
  String _sortBy = 'uploadedAt';
  bool _sortAscending = false;
  DashboardColors dashColors = DashboardColors();

  // Function to open the uploaded file
  Future<void> _viewFile(String url) async {
    final Uri fileUrl = Uri.parse(url);
    if (!await launchUrl(fileUrl, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open file.')));
    }
  }

  // Sort option bottom sheet
  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: Text(
                'Sort by Name (A-Z)',
                style: TextStyles.monText(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: dashColors.textDarkColor,
                ),
              ),
              onTap: () {
                setState(() {
                  _sortBy = 'fileName';
                  _sortAscending = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: Text(
                'Sort by Name (Z-A)',
                style: TextStyles.monText(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: dashColors.textDarkColor,
                ),
              ),
              onTap: () {
                setState(() {
                  _sortBy = 'fileName';
                  _sortAscending = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                'Sort by Date (Newest first)',
                style: TextStyles.monText(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: dashColors.textDarkColor,
                ),
              ),
              onTap: () {
                setState(() {
                  _sortBy = 'uploadedAt';
                  _sortAscending = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                'Sort by Date (Oldest first)',
                style: TextStyles.monText(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: dashColors.textDarkColor,
                ),
              ),
              onTap: () {
                setState(() {
                  _sortBy = 'uploadedAt';
                  _sortAscending = true;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _showSortOptions,
                  icon: Icon(Icons.sort, color: dashColors.textDarkColor),
                  label: Text(
                    "Sort",
                    style: TextStyles.monText(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: dashColors.textDarkColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Filter logic not implemented.'),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.filter_list,
                    color: dashColors.textDarkColor,
                  ),
                  label: Text(
                    "Filter",
                    style: TextStyles.monText(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: dashColors.textDarkColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Patients')
                    .doc(widget.patientId)
                    .collection('uploads')
                    .orderBy(_sortBy, descending: !_sortAscending)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No documents shared by your doctor yet.",
                        style: TextStyles.monText(),
                      ),
                    );
                  }

                  final files = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final fileData =
                          files[index].data() as Map<String, dynamic>;
                      final String fileName = fileData['fileName'] ?? 'No Name';
                      final String fileUrl = fileData['fileUrl'];
                      final Timestamp uploadedAt =
                          fileData['uploadedAt'] ?? Timestamp.now();
                      final String formattedDate = DateFormat(
                        'MMMM dd, yyyy',
                      ).format(uploadedAt.toDate());

                      return Card(
                        color: Colors.white,
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Icon(
                            _getIconForFileType(fileData['fileType']),
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(fileName, style: TextStyles.monText()),
                          subtitle: Text(
                            "Uploaded on $formattedDate",
                            style: TextStyles.monText(fontSize: 12),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _viewFile(fileUrl),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForFileType(String? fileType) {
    switch (fileType?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.article;
      default:
        return Icons.insert_drive_file;
    }
  }
}
