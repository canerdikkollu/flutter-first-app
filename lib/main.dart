import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyAppHome());
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  String userName = "";
  String lorem =
      "                       Lorem Ipsum is simply dummy text of the printing and type setting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
          .toLowerCase()
          .replaceAll(',', '')
          .replaceAll('.', '');
  int step = 0;
  int lastTypedAt = 0;
  int typedCharsLength = 0;

  void updateLastTypedAt() {
    this.lastTypedAt = new DateTime.now().millisecondsSinceEpoch;
  }

  void onUserNameType(String value) {
    setState(() {
      this.userName = value.substring(0,10);
    });
  }

  void onType(String value) {
    updateLastTypedAt();
    String trimmedValue = lorem.trimLeft();

    setState(() {
      if (trimmedValue.indexOf(value) != 0) {
        step = 2;
      } else {
        typedCharsLength = value.length;
      }
    });
  }

  void resetGame() {
    setState(() {
      typedCharsLength = 0;
      step = 0;
    });
  }

  void onStartClick() {
    setState(() {
      updateLastTypedAt();
      step++;
    });

    var timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      // For game over
      int now = new DateTime.now().millisecondsSinceEpoch;
      setState(() {
        if (step == 1 && now - lastTypedAt > 4000) {
          timer.cancel();
          step++;
        }
        if (step != 1) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;
    if (step == 0)
      shownWidget = <Widget>[
        Text('Welcome, Are you ready?'),
        Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onChanged: onUserNameType,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Username'),
            )),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text('Start!'),
            onPressed: userName.length == 0 ? null : onStartClick,
          ),
        )
      ];
    else if (step == 1)
      shownWidget = <Widget>[
        Text('$typedCharsLength'),
        Container(
          height: 40,
          child: Marquee(
            text: lorem,
            style: TextStyle(fontSize: 24, letterSpacing: 2),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20,
            velocity: 125,
            startPadding: 0, //MediaQuery.of(context).size.width,
            accelerationDuration: Duration(seconds: 15),
            accelerationCurve: Curves.ease,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
          child: TextField(
            onChanged: onType,
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Type'),
          ),
        )
      ];
    else
      shownWidget = <Widget>[
        Text('Game Over! Score: $typedCharsLength'),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text('Restart'),
            onPressed: resetGame,
          ),
        )
      ];

    return Scaffold(
        appBar: AppBar(
          title: Text('Type'),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: shownWidget),
        ));
  }
}
