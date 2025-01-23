import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qpoll/Constants/constants.dart';

class PollResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poll Results'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('results').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No poll results available.'));
          }

          final resultsByPoll = <String, List<QueryDocumentSnapshot>>{};

          // Group results by poll name
          for (var result in snapshot.data!.docs) {
            final pollName = result['pollName'] ?? 'Unknown Poll';
            if (!resultsByPoll.containsKey(pollName)) {
              resultsByPoll[pollName] = [];
            }
            resultsByPoll[pollName]!.add(result);
          }

          return ListView.builder(
            itemCount: resultsByPoll.keys.length,
            itemBuilder: (context, index) {
              final pollName = resultsByPoll.keys.elementAt(index);
              final results = resultsByPoll[pollName]!;

              return Card(
                margin: EdgeInsets.all(12),
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pollName,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryColor),
                      ),
                      SizedBox(height: 8),
                      Text('Candidates and their votes:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      for (var result in results)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Text(result['candidateName'] ?? 'Unknown Candidate'),
                              Spacer(),
                              Text('${result['voteCount'] ?? 0} votes'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}