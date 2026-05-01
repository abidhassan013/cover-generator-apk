import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const AssignmentCoverApp());
}

class AssignmentCoverApp extends StatelessWidget {
  const AssignmentCoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PSTU Assignment Cover Generator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  // Header Controllers
  final yearSemesterController = TextEditingController();
  final examYearController = TextEditingController();
  final sessionController = TextEditingController();
  final assignmentNoController = TextEditingController();

  // Course Controllers
  final courseTitleController = TextEditingController();
  final courseCodeController = TextEditingController();

  // Submitted By Controllers
  final studentNameController = TextEditingController();
  final studentIdController = TextEditingController();
  final studentSessionController = TextEditingController();
  final submissionDateController = TextEditingController();

  // Submitted To Controllers
  final teacherNameController = TextEditingController();
  final teacherRankController = TextEditingController();
  final departmentController = TextEditingController();
  final universityController = TextEditingController(text: "Pirojpur Science and Technology University");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignment Info Input"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Main Header Info"),
            _buildTextField(yearSemesterController, "Year & Semester"),
            _buildTextField(examYearController, "Examination Year"),
            _buildTextField(sessionController, "Session"),
            _buildTextField(assignmentNoController, "Assignment No"),

            const Divider(height: 30),
            _buildSectionHeader("Course Details"),
            _buildTextField(courseTitleController, "Course Title"),
            _buildTextField(courseCodeController, "Course Code"),

            const Divider(height: 30),
            _buildSectionHeader("Submitted By (Student)"),
            _buildTextField(studentNameController, "Student Name"),
            _buildTextField(studentIdController, "Student ID"),
            _buildTextField(studentSessionController, "Student Session"),
            _buildTextField(submissionDateController, "Submission Date"),

            const Divider(height: 30),
            _buildSectionHeader("Submitted To (Teacher)"),
            _buildTextField(teacherNameController, "Teacher Name"),
            _buildTextField(teacherRankController, "Rank"),
            _buildTextField(departmentController, "Department"),
            _buildTextField(universityController, "University Name"),

            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                
                  Map<String, String> data = {
                    'yearSemester': yearSemesterController.text,
                    'session': sessionController.text,
                    'assignmentNo': assignmentNoController.text,
                    'courseTitle': courseTitleController.text,
                    'courseCode': courseCodeController.text,
                    'studentName': studentNameController.text,
                    'studentId': studentIdController.text,
                    'studentSession': studentSessionController.text,
                    'submissionDate': submissionDateController.text,
                    'teacherName': teacherNameController.text,
                    'teacherRank': teacherRankController.text,
                    'department': departmentController.text,
                    'university': universityController.text,
                  };
                  generatePdf(data);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text("Generate Cover PDF", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}



Future<void> generatePdf(Map<String, String> data) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.FullPage(
          ignoreMargins: false,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(40),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey, width: 0.5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Header section
                pw.Text(data['yearSemester']!, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.Text("Session: ${data['session']}", style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 5),
                pw.Text("Assignment ${data['assignmentNo']}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),

                pw.SizedBox(height: 80), 

                // Course Info
                pw.Text("Course Title: ${data['courseTitle']}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.Text("Course Code: ${data['courseCode']}", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),

                
                pw.SizedBox(height: 180),

                // Submitted To & By Row
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Submitted To
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Submitted to-", style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
                        pw.SizedBox(height: 12),
                        pw.Text(data['teacherName']!, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                        pw.Text(data['teacherRank']!, style: const pw.TextStyle(fontSize: 12)),
                        pw.Text("Department of ${data['department']}", style: const pw.TextStyle(fontSize: 12)),
                        pw.Text(data['university']!, style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    // Submitted By
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Submitted by-", style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
                        pw.SizedBox(height: 12),
                        pw.Row(children: [pw.SizedBox(width: 60, child: pw.Text("Name")), pw.Text(": ${data['studentName']}")]),
                        pw.Row(children: [pw.SizedBox(width: 60, child: pw.Text("Student ID")), pw.Text(": ${data['studentId']}")]),
                        pw.Row(children: [pw.SizedBox(width: 60, child: pw.Text("Session")), pw.Text(": ${data['studentSession']}")]),
                        pw.Row(children: [pw.SizedBox(width: 60, child: pw.Text("Date")), pw.Text(": ${data['submissionDate']}")]),
                      ],
                    ),
                  ],
                ),

                pw.Spacer(),

                // Footer
                pw.Text("Department of ${data['department']!}", style: const pw.TextStyle(fontSize: 14)),
                pw.Text(data['university']!, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text("Pirojpur- 8500, Bangladesh", style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
