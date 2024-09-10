import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Divider(
            height: 4.0,
            thickness: 1,
            color: Color(0x61693BB8),
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              """
              This app was developed by Shyam Srinivasan, a passionate student of the Computer Science Engineering 2022-2026 batch at REC. With the goal of making food ordering more convenient and efficient for fellow students, this app allows students to browse, order, and pay for food seamlessly.

The idea was shaped with valuable input from my friends, including Raghul, who provided key insights during development, and Praveen, Rehan, Guru, Sanjay, and Satish, whose constant support and feedback helped bring the project to life.

What started as a small idea is now a fully functional app aimed at enhancing the food ordering experience at REC. We hope it makes your day easier!
              """,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'With a vision to simplify campus life, this app allows students to browse, order, and pay for food seamlessly. The idea was shaped with valuable input from my friends, including Raghul, who provided key insights during development, and Praveen, Rehan, Guru, Sanjay, and Satish, whose constant support and feedback helped bring the project to life.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'What started as a small idea is now a fully functional app aimed at enhancing the food ordering experience at REC. We hope it makes your day easier!',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
