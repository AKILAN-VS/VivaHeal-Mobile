import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/text_styles.dart'; // ✅ adjust path if different

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({Key? key}) : super(key: key);

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _illnessController = TextEditingController();
  DateTime? _selectedDateTime;
  String? _selectedDoctorId;
  String? _patientName;

  bool _isLoading = false;
  List<Map<String, dynamic>> _doctors = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
    _fetchPatientName();
  }

  Future<void> _fetchDoctors() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users') // or 'Users' if your collection is capitalized
          .where('role', isEqualTo: 'doctor')
          .get();

      setState(() {
        _doctors = snapshot.docs
            .map(
              (doc) => {
                'id': doc.id,
                'name': doc.data().containsKey('name') ? doc['name'] : 'Doctor',
                'specialization': doc.data().containsKey('specialization')
                    ? doc['specialization']
                    : 'General',
              },
            )
            .toList();
      });

      print("✅ Fetched doctors: ${_doctors.length}");
    } catch (e) {
      print("❌ Error fetching doctors: $e");
    }
  }

  Future<void> _fetchPatientName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() => _patientName = doc['name'] ?? 'Unknown');
      }
    } catch (e) {
      debugPrint('Error fetching patient name: $e');
    }
  }

  Future<void> _bookAppointment() async {
    if (!_formKey.currentState!.validate() ||
        _selectedDoctorId == null ||
        _selectedDateTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    try {
      setState(() => _isLoading = true);
      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('appointments').add({
        'appointmentDate': _selectedDateTime,
        'confirmation': false,
        'doctorID': _selectedDoctorId,
        'illness': _illnessController.text.trim(),
        'isCompleted': false,
        'patientID': user?.uid,
        'patientName': _patientName ?? 'Unknown',
        'status': 'requested',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment booked successfully')),
      );

      setState(() {
        _isLoading = false;
        _illnessController.clear();
        _selectedDoctorId = null;
        _selectedDateTime = null;
      });
    } catch (e) {
      debugPrint('Error booking appointment: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to book appointment: $e')));
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Book Appointment',
          style: TextStyles.monText(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor label
                    Text(
                      'Select Doctor',
                      style: TextStyles.monText(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Doctor dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedDoctorId,
                      items: _doctors
                          .map<DropdownMenuItem<String>>(
                            (doc) => DropdownMenuItem<String>(
                              value: doc['id'] as String,
                              child: Text(
                                "${doc['name']} (${doc['specialization']})",
                                style: TextStyles.monText(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedDoctorId = value),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Choose a doctor',
                        hintStyle: TextStyles.monText(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      validator: (value) =>
                          value == null ? 'Please select a doctor' : null,
                    ),
                    const SizedBox(height: 18),

                    // Date & time
                    Text(
                      'Appointment Date & Time',
                      style: TextStyles.monText(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _selectDateTime,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedDateTime == null
                              ? 'Select date & time'
                              : '${_selectedDateTime!.toLocal()}'.split('.')[0],
                          style: TextStyles.monText(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Illness / reason
                    Text(
                      'Illness / Reason for Visit',
                      style: TextStyles.monText(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _illnessController,
                      maxLines: 3,
                      style: TextStyles.monText(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your illness or reason',
                        hintStyle: TextStyles.monText(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Please enter illness'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F3E50),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _bookAppointment,
                        child: Text(
                          'Book Appointment',
                          style: TextStyles.monText(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ).copyWith(color: Colors.white),
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
