import 'package:flutter/material.dart';

class Uploads extends StatelessWidget {
  final List<Map<String, String>> uploadedFiles = [
    {"name": "MRI Report", "date": "2024-01-15"},
    {"name": "Blood Test Results", "date": "2024-01-10"},
    {"name": "X-Ray Image", "date": "2024-01-05"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Sorting logic
                  },
                  icon: const Icon(Icons.sort),
                  label: const Text("Sort"),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Filtering logic
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text("Filter"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: uploadedFiles.length,
                itemBuilder: (context, index) {
                  final file = uploadedFiles[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.insert_drive_file_outlined),
                      title: Text(file["name"]!),
                      subtitle: Text("Uploaded on ${file["date"]}"),
                      onTap: () {
                        // TODO: Open file preview
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
