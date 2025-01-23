import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPollScreen extends StatefulWidget {
  final String pollId;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime resultDateTime;
  final List<String> positions;

  EditPollScreen({
    required this.pollId,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.resultDateTime,
    required this.positions,
  });

  @override
  _EditPollScreenState createState() => _EditPollScreenState();
}

class _EditPollScreenState extends State<EditPollScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _resultDateController;
  late TextEditingController _positionsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    _startDateController = TextEditingController(text: widget.startDate.toString());
    _endDateController = TextEditingController(text: widget.endDate.toString());
    _resultDateController = TextEditingController(text: widget.resultDateTime.toString());
    _positionsController = TextEditingController(text: widget.positions.join(', '));
  }

  Future<void> _updatePoll() async {
    if (_formKey.currentState!.validate()) {
      final updatedPoll = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'startDate': DateTime.parse(_startDateController.text),
        'endDate': DateTime.parse(_endDateController.text),
        'resultDateTime': DateTime.parse(_resultDateController.text),
        'positions': _positionsController.text.split(',').map((e) => e.trim()).toList(),
      };

      await FirebaseFirestore.instance
          .collection('Public_polls')
          .doc(widget.pollId)
          .update(updatedPoll);


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Poll updated successfully.')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _resultDateController.dispose();
    _positionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Poll'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Poll Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter poll name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(labelText: 'Start Date (YYYY-MM-DD)'),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter start date';
                    }
                    try {
                      DateTime.parse(value);
                    } catch (e) {
                      return 'Invalid date format';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(labelText: 'End Date (YYYY-MM-DD)'),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter end date';
                    }
                    try {
                      DateTime.parse(value);
                    } catch (e) {
                      return 'Invalid date format';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _resultDateController,
                  decoration: InputDecoration(labelText: 'Result Date (YYYY-MM-DD)'),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter result date';
                    }
                    try {
                      DateTime.parse(value);
                    } catch (e) {
                      return 'Invalid date format';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _positionsController,
                  decoration: InputDecoration(labelText: 'Positions (comma separated)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter positions';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updatePoll,
                  child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
