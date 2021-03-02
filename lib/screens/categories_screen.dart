import 'package:ecommerce_vendor/providers/bookings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../widgets/category_item.dart';
import '../widgets/new_movie.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = 'categories';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _firebaseMessaging.subscribeToTopic("vendorApp");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('New Notification!!'),
            content: Container(
              height: 50,
              child: Column(
                children: [
                  Text(
                    message['notification']['title'],
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(message['notification']['body']),
                ],
              ),
            ),
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
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print('user_token: ' + token);
    });
  }

  void _startAddNewMovie(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewMovie(),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Bookings>(context, listen: false)
        .fetchBookings(); // load booking early
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies App'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewMovie(context),
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: categoriesMap
              .map((catData) => CategoryItem(
                    catData.id,
                    catData.label,
                    catData.color,
                  ))
              .toList(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => _startAddNewMovie(context),
        backgroundColor: Colors.blueGrey[900],
      ),
    );
  }
}
