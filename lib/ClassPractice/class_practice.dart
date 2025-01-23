import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Week12home extends StatefulWidget {
  const Week12home({super.key});

  @override
  State<Week12home> createState() => _Week12homeState();
}

class _Week12homeState extends State<Week12home> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("CRUD APP"),),
      floatingActionButton: FloatingActionButton(onPressed: ()
      {
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text("Add Data"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      hintText: "Title",
                      labelText: "Title of Product"
                  ),),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      hintText: "Description",
                      labelText: "Description of Product"
                  ),),
                TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                      hintText: "Quantity",
                      labelText: "Quatity"
                  ),),
              ],
            ),
            actions: [
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),
              ElevatedButton(onPressed: (){
                try{
                  FirebaseFirestore.instance.collection("Week12").doc(_titleController.text).set({
                    "title": _titleController.text,
                    "description":_descriptionController.text,
                    "quantity":_quantityController.text,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Sucessfully added")));

                }on FirebaseException catch(err){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error" + err.code.toString())));
                }

              }, child: Text("AddData")),


            ],
          );
        });
      },
        child: Icon(Icons.add),
      ),
    );
  }
}