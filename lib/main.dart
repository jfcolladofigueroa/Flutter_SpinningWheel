import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFC77BBD),
        child: InkWell(
            child: Center(
              child: Text(
                'Las vocales',
                style: TextStyle(fontSize: 30),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Roulette()),
              );
            }),
      ),
    );
  }
}

class Roulette extends StatelessWidget {
  final StreamController _dividerController = StreamController<int>();
  final StreamController _dividerFinalController = StreamController<int>();

  final _wheelNotifier = StreamController<double>();

  dispose() {
    _dividerController.close();
    _dividerFinalController.close();
    _wheelNotifier.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xffDDC3FF), elevation: 0.0),
      backgroundColor: Color(0xffDDC3FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinningWheel(
              Image.asset('assets/images/rueda.png'),
              width: 310,
              height: 310,
              initialSpinAngle: _generateRandomAngle(),
              spinResistance: 0.4,
              canInteractWhileSpinning: false,
              dividers: 5,
              onUpdate: _dividerController.add,
              onEnd: _dividerFinalController.add,
              secondaryImage:
                  Image.asset('assets/images/roulette-center-300.png'),
              secondaryImageHeight: 80,
              secondaryImageWidth: 80,
              shouldStartOrStop: _wheelNotifier.stream,
            ),
            SizedBox(height: 30),
            StreamBuilder(
              stream: _dividerController.stream,
              builder: (context, snapshot) =>
                  snapshot.hasData ? RouletteScore(snapshot.data) : Container(),
            ),
            StreamBuilder(
              stream: _dividerFinalController.stream,
              builder: (context, snapshot) =>
                  // snapshot.hasData ? RouletteScore(snapshot.data) : Container(),
                  snapshot.hasData ? SomeDialog(snapshot.data) : Container(),
            ),
            SizedBox(height: 30),
            new ElevatedButton(
              child: new Text("Inicio"),
              onPressed: () =>
                  _wheelNotifier.sink.add(_generateRandomVelocity()),
            ),
            // new ElevatedButton(
            //     onPressed: () => {_showMyDialog(context)},
            //     child: new Text("Prueba"))
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double _generateRandomVelocity() => (Random().nextDouble() * 6000) + 2000;

  double _generateRandomAngle() => Random().nextDouble() * pi * 2;
}

class RouletteScore extends StatelessWidget {
  final int selected;

  final Map<int, String> labels = {
    1: 'A',
    2: 'E',
    3: 'I',
    4: 'O',
    5: 'U',
  };

  RouletteScore(this.selected);

  @override
  Widget build(BuildContext context) {
    return Text('${labels[selected]}',
        style: TextStyle(
            fontStyle: FontStyle.normal, fontSize: 44.0, color: Colors.pink));
  }
}

class SomeDialog extends StatelessWidget {
  final int selected;

  SomeDialog(this.selected);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: InkWell(
            child: Image.asset('assets/images/$selected.jpg'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Animal(selected)),
              );
            }));
  }
}

class Animal extends StatelessWidget {
  final int selected;
  String animal;
  Animal(this.selected);
  setText() {
    switch (selected) {
      case 1:
        animal = "ABEJA";
        break;
      case 2:
        animal = "ELEFANTE";
        break;
      case 3:
        animal = "IGUANA";
        break;
      case 4:
        animal = "OSO";
        break;
      case 5:
        animal = "UNICORNIO";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    setText();
    return Scaffold(
        appBar: AppBar(backgroundColor: Color(0xffDDC3FF), elevation: 0.0),
        backgroundColor: Color(0xffDDC3FF),
        body: Column(children: [
          Text(
            animal,
            style: TextStyle(fontSize: 50),
          ),
          Center(
            child: Image.asset('assets/images/$selected.jpg'),
          )
        ]));
  }
}
