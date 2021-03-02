import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/bookings.dart';
import '../widgets/movie_slot.dart';

class BookingScreen extends StatefulWidget {
  static const routeName = 'bookings';
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

Widget _noneSlot(String text) {
  return Card(
    elevation: 0,
    color: Colors.blueGrey,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(
        text,
        style: TextStyle(color: Colors.blueGrey),
      ),
    ),
  );
}

List<Widget> _buildColumnSlot(String movieId, List<int> pickedSeats) {
  List<Widget> slots = [];
  List<String> letters = ['A', 'B', 'C', 'D', 'E'];
  for (var i = 0; i < 5; i++) {
    slots.add(
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [..._buildRowSlot(letters, i, movieId, pickedSeats)],
          ),
        ],
      ),
    );
  }
  return slots;
}

List<Widget> _buildRowSlot(
    List<String> letters, int row, String movieId, List<int> pickedSeats) {
  List<Widget> slots = [];
  for (var i = 0; i < 11; i++) {
    if (row == 0 && i == 4) {
      slots.add(_noneSlot('${letters[row]}${i + 1}'));
    } else if (row == 0 && i == 5) {
      slots.add(_noneSlot('${letters[row]}${i + 1}'));
    } else if (row == 1 && i == 5) {
      slots.add(_noneSlot('${letters[row]}${i + 1}'));
    } else if (row == 2 && i == 5) {
      slots.add(_noneSlot('${letters[row]}${i + 1}'));
    } else if (row == 3 && i == 5) {
      slots.add(_noneSlot('${letters[row]}${i + 1}'));
    } else if (row == 1 && i == 4) {
      slots.add(_noneSlot('${letters[row]}${i + 1}'));
    } else if (row == 2 && i == 4) {
      slots.add(_noneSlot('${letters[row]}${i + 1}'));
    } else if (row == 3 && i == 4) {
      slots.add(_noneSlot('${letters[row]}${i + 1}'));
    } else {
      slots.add(
        MovieSlot(
          text: '${letters[row]}${i + 1}',
          value: ((row * 11) + (i + 1)),
          movieId: movieId,
          seats: pickedSeats,
        ),
      );
    }
  }
  return slots;
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final movieId = ModalRoute.of(context).settings.arguments as String;
    List<int> pickedSeats = [];
    Provider.of<Bookings>(context, listen: false).fetchBookings();
    pickedSeats = Provider.of<Bookings>(context, listen: false)
        .findById(movieId)
        .seats
        .cast<int>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
      ),
      backgroundColor: Colors.blueGrey,
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                  child: Text(
                    'Screen',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ..._buildColumnSlot(movieId, pickedSeats),
            ],
          ),
        ),
      ),
    );
  }
}
