import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mep/app/views/report/my_reports/report_card.dart';
import '../../../data/models/report_model.dart';
import '../../home/home_view.dart';
import '../../profile/profile_page.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({Key? key}) : super(key: key);

  @override
  _MyReportsPageState createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Reports"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('report')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<QueryDocumentSnapshot> documents = snapshot.data!.docs.toList();
            final List<ReportData> reportDataList = documents.map((doc) {
              final String id = doc.id; // Get the document ID
              final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return ReportData(id: id, data: data); // Create a custom object containing ID and data
            }).toList();

            List<Report> reports = reportDataList.map((reportData) {
              // Convert the custom object to a Report object
              return Report.fromJson(reportData.id, reportData.data);
            }).toList();

            if (reports.isEmpty) {
              return Center(child: Text('No reports available.'));
            } else {
              return ReportCard(reports: reports);
            }
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF325A3E),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // 'Reports' sayfasına yönlendirme yapılabilir (şu anda 'MyReportsPage' zaten aktif olduğundan bir şey yapmaya gerek yok)
    } else if (index == 1) {
      // 'Home' sayfasına yönlendirme yapılabilir
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 2) {
      // 'Profile' sayfasına yönlendirme yapılabilir
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }


}

class ReportData {
  final String id;
  final Map<String, dynamic> data;

  ReportData({required this.id, required this.data});
}
