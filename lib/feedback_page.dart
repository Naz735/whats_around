import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(labelText: "Your feedback"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement feedback submission logic later
                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
