import 'package:ecommerce_vendor/screens/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/categories_screen.dart';
import './screens/movies_screen.dart';
import './providers/movies.dart';
import './providers/bookings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Movies(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Bookings(),
          ),
        ],
        builder: (ctx, child) => MaterialApp(
              title: 'Manage Movies',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                appBarTheme: ThemeData.light()
                    .appBarTheme
                    .copyWith(color: Colors.blueGrey[900]),
                primarySwatch: Colors.blue,
                accentColor: Colors.amber,
                canvasColor: Color.fromRGBO(255, 254, 229, 1),
                fontFamily: 'Raleway',
                textTheme: ThemeData.light().textTheme.copyWith(
                      bodyText1: TextStyle(
                        color: Color.fromRGBO(20, 51, 51, 1),
                      ),
                      bodyText2: TextStyle(
                        color: Color.fromRGBO(20, 51, 51, 1),
                      ),
                      headline6: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'RobotoCondense',
                          fontWeight: FontWeight.w400),
                    ),
              ),
              // home: CategoriesScreen(),
              initialRoute: '/', // default is '/'
              routes: {
                '/': (ctx) => CategoriesScreen(),
                MoviesScreen.routeName: (ctx) => MoviesScreen(),
                BookingScreen.routeName: (ctx) => BookingScreen(),
              },
              onUnknownRoute: (settings) {
                return MaterialPageRoute(
                  builder: (ctx) => CategoriesScreen(),
                );
              },
            ));
  }
}
