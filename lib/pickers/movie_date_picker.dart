import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class MovieDatePicker extends StatefulWidget {
  final void Function(DateTime date, TimeOfDay time) dateTimePickFn;

  MovieDatePicker(this.dateTimePickFn);
  @override
  _MovieDatePickerState createState() => _MovieDatePickerState();
}

class _MovieDatePickerState extends State<MovieDatePicker> {
  DateTime _selectedDate;
  TimeOfDay _selectedTime;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2050),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      showTimePicker(context: context, initialTime: TimeOfDay.now())
          .then((pickedTime) {
        if (pickedTime == null) {
          return;
        }
        setState(() {
          _selectedTime = pickedTime;
          _selectedDate = pickedDate;
          widget.dateTimePickFn(pickedDate, pickedTime);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_selectedDate == null
              ? 'Not Date Chosen!'
              : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)} ${_selectedTime.toString().substring(10).replaceAll(')', '')}'),
          FlatButton(
            child: Text(
              'Choose Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _presentDatePicker,
            textColor: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
