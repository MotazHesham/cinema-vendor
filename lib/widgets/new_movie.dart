import 'package:ecommerce_vendor/models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../pickers/movie_image_picker.dart';
import '../pickers/movie_date_picker.dart';
import '../providers/movies.dart';

class NewMovie extends StatefulWidget {
  @override
  _NewMovieState createState() => _NewMovieState();
}

class _NewMovieState extends State<NewMovie> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  Category selectedCategory;
  File _image;
  var _isLoading = false;

  void _pickedImage(File image) {
    _image = image;
  }

  void _pickedDateTime(DateTime date, TimeOfDay time) {
    _selectedDate = date;
    _selectedTime = time;
  }

  Future<void> _submitData() async {
    final enteredTitle = _titleController.text;
    final enteredDescription = _descriptionController.text;
    setState(() {
      _isLoading = true;
    });
    if (enteredTitle.isEmpty ||
        enteredDescription.isEmpty ||
        selectedCategory == null ||
        _image == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please fill all fields....',
                style: TextStyle(color: Colors.redAccent),
              ),
            );
          });
      return;
    }
    try {
      await Provider.of<Movies>(context, listen: false).addNewMovie(
        txTitle: enteredTitle,
        txDescription: enteredDescription,
        chosenDate: _selectedDate,
        chosenTime: _selectedTime,
        categoryId: selectedCategory.id,
        cover: _image,
      );
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Success!'),
          content: Text('Movie Inserted Successfully!'),
          actions: [
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error occured!'),
          content: Text('Some Thing Went Wrong!'),
          actions: [
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: MovieImagePicker(_pickedImage),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                      onSubmitted: (_) => _submitData(),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Description'),
                      controller: _descriptionController,
                      onSubmitted: (_) => _submitData(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 13),
                        height: mediaQuery.size.height * 0.03,
                        child: DropdownButtonFormField<Category>(
                          decoration: InputDecoration.collapsed(hintText: ''),
                          hint: Text('Select Category'),
                          value: selectedCategory != null
                              ? Category.categoriesMap2.firstWhere(
                                  (c) => c.id == selectedCategory.id)
                              : selectedCategory,
                          items: Category.categoriesMap2.map(
                            (value) {
                              return DropdownMenuItem<Category>(
                                value: value,
                                child: Text(value.label),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: MovieDatePicker(_pickedDateTime),
                    ),
                    Center(
                      child: RaisedButton(
                        child: Text('Add'),
                        onPressed: _submitData,
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
