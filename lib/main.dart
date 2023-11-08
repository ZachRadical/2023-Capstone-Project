import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme:
            TextTheme(headline2: TextStyle(color: Colors.lightGreenAccent))
                .apply(
                    bodyColor: Colors.lightGreenAccent,
                    displayColor: Colors.lightGreenAccent),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.jpg"), fit: BoxFit.cover)),
        child: Container(
          margin: EdgeInsets.all(50),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.lightGreenAccent),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 700,
                  width: 600,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.lightGreenAccent),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/zfold5.jpg", fit: BoxFit.contain),
                      Container(
                          margin: EdgeInsets.only(top: 25),
                          child: const Text('Samsung Galazy Z Fold 5'))
                    ],
                  )),
              questionList
            ],
          ),
        ),
      ),
    );
  }
}

const listTextStyle = TextStyle(
  color: Colors.lightGreenAccent,
  fontWeight: FontWeight.w800,
  fontFamily: 'Roboto',
  letterSpacing: 0.5,
  fontSize: 18,
  height: 2,
);

final questionList = DefaultTextStyle.merge(
    style: listTextStyle,
    child: Container(
      margin: EdgeInsets.all(50),
      padding: EdgeInsets.all(20),
      width: 450,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightGreenAccent),
      ),
      child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
                'To ask a question, press the mute button on the side of the headset'),
            Text('data'),
            Text('data'),
            Text('data')
          ]),
    ));
