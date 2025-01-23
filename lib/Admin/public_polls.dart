import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qpoll/Constants/constants.dart';

import 'edit_poll.dart';

class AdminPublicPollsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Public Polls Management'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        color: Colors.blueGrey[50], // Updated background color
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Public_polls').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final polls = snapshot.data!.docs;

            if (polls.isEmpty) {
              return Center(child: Text('No public polls available.', style: TextStyle(fontSize: 16, color: Colors.grey[600])));
            }

            return ListView.builder(
              itemCount: polls.length,
              itemBuilder: (context, index) {
                final poll = polls[index].data() as Map<String, dynamic>;
                final pollId = polls[index].id;
                final name = poll['name'] ?? 'No Name';
                final description = poll['description'] ?? 'No Description';
                final startDate = poll['startDate']?.toDate() ?? DateTime.now();
                final endDate = poll['endDate']?.toDate() ?? DateTime.now();
                final resultDateTime = poll['resultDateTime']?.toDate() ?? DateTime.now();
                final positions = List<String>.from(poll['positions'] ?? []);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPollScreen(
                          pollId: pollId,
                          name: name,
                          description: description,
                          startDate: startDate,
                          endDate: endDate,
                          resultDateTime: resultDateTime,
                          positions: positions,
                        ),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: kPrimaryColor),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Description: $description',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Start Date: ${startDate.toLocal()}',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'End Date: ${endDate.toLocal()}',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'Result Date: ${resultDateTime.toLocal()}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Text(
                          'Positions: ${positions.join(', ')}',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPollScreen(
                                      pollId: pollId,
                                      name: name,
                                      description: description,
                                      startDate: startDate,
                                      endDate: endDate,
                                      resultDateTime: resultDateTime,
                                      positions: positions,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () async {
                                final confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Delete Poll'),
                                      content: Text('Are you sure you want to delete this poll?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text('Delete'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmDelete ?? false) {
                                  await FirebaseFirestore.instance
                                      .collection('Public_polls')
                                      .doc(pollId)
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Poll deleted successfully.')),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
