import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'updated_database.dart' as phone_specs;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

//********************************************
//****************App Logic*******************
//********************************************
class MyHomePageState extends State<MyHomePage> {
  late SpeechToText _speech;
  FlutterTts flutterTts = FlutterTts();
  bool _isListening = false;
  String _recognizedSpeech = '';
  String _displayedAnswer = '';
  String _spokenAnswer = '';

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    bool available = await _speech.initialize(
      onError: (error) => debugPrint('Error: $error'),
      onStatus: (status) => debugPrint('Status: $status'),
    );
    if (!available) {
      debugPrint('Speech recognition not available');
    }
  }

  void _toggleListening() {
    if (!_isListening) {
      _startListening();
    } else {
      _stopListening();
    }
    setState(() {
      _isListening = !_isListening;
    });
  }

  void _startListening() async {
    if (!_speech.isAvailable || !_speech.isListening) {
      bool available = await _speech.initialize(
        onError: (error) => debugPrint('Error: $error'),
        onStatus: (status) => debugPrint('Status: $status'),
      );
      if (!available) {
        debugPrint('Speech recognition not available');
        return;
      }
    }

    if (!_speech.isListening) {
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            setState(() {
              _recognizedSpeech = result.recognizedWords;
            });
            _displayAnswer(
                _recognizedSpeech); // Display the answer for recognized text
          } else {
            setState(() {
              _recognizedSpeech = result.recognizedWords;
            });
          }
        },
      );
    }
  }

  void _stopListening() {
    if (_speech.isListening) {
      _speech.stop();
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-US');

    // Setting voice parameters for natural sound
    await flutterTts.setPitch(1.0); // 1.0 is the normal pitch
    await flutterTts.setSpeechRate(1.0); // 1.0 is the normal speech rate
    await flutterTts.setVolume(1.0); // 1.0 is the maximum volume

    await flutterTts.speak(text);
  }

  void _displayAnswer(String recognizedSpeech) {
    // Implementing logic to find an answer based on a keyword in the recognized speech

    List<String> foundAnswers = []; //Default value
    List<String> foundDisplayAnswers = []; //Default value

    //The spoken database removes acronyms from the bot's speech patterns, this way it will
    //display things like "mp" but the bot will still say "megapixel"
    phone_specs.spokenResponse.forEach((question, answer) {
      if (recognizedSpeech.toLowerCase().contains(question.toLowerCase())) {
        foundAnswers.add(answer);
        return;
      }
    });

    phone_specs.displayedResponse.forEach((question, answer) {
      if (recognizedSpeech.toLowerCase().contains(question.toLowerCase())) {
        foundDisplayAnswers.add(answer);
        return;
      }
    });

    setState(() {
      _displayedAnswer =
          foundDisplayAnswers.join('\n'); // Set the displayed answer
      _spokenAnswer = foundAnswers.join('\n'); // Set the answer to be spoken
    });

    _speak(_spokenAnswer); // Speak the found answer
  }

//*************************************************
//*******************Styling***********************
//*************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Background image
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Galaxy-Z-Fold-5-renders-2.jpg"),
            fit: BoxFit.fill,
          ),
        ),

        //Column outline
        child: Container(
          /*decoration: BoxDecoration(border: Border.all(color: Colors.black)),*/
          height: 300,
          width: 1100,
          margin:
              const EdgeInsets.only(bottom: 50, left: 50, right: 50, top: 160),

          //Main column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Title Frame
              Container(
                alignment: Alignment.center,

                //Still not entirely sure what this does
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),

                  //Title
                  child: Text(
                    "Samsung Galaxy Z Fold 5",
                    style: TextStyle(
                        fontSize: 56,
                        //Adds color gradient to title text
                        foreground: Paint()
                          ..shader = ui.Gradient.linear(
                            const Offset(0, 20),
                            const Offset(7, 0),
                            <Color>[
                              Colors.lightBlue,
                              Colors.lightBlueAccent,
                            ],
                          ),

                        //Shadows creates the white border effect on the title
                        //May scrap this
                        shadows: const [
                          Shadow(
                              // bottomLeft
                              offset: Offset(-1.0, -1.0),
                              color: Colors.white),
                          Shadow(
                              // bottomRight
                              offset: Offset(1.0, -1.0),
                              color: Colors.white),
                          Shadow(
                              // topRight
                              offset: Offset(1.0, 1.0),
                              color: Colors.white),
                          Shadow(
                              // topLeft
                              offset: Offset(-1.0, 1.0),
                              color: Colors.white),
                        ]),
                  ),
                ),
              ),

              //Frame to hold row
              SizedBox(
                height: 100,
                //Row for input, button, and output
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //Text input box
                    Container(
                        width: 475,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.6),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),

                        //Input text
                        //Center keeps the text vertically centered
                        //TextAlign.Center keeps it horizontally centered
                        child: Center(
                          child: Text(_recognizedSpeech,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24)),
                        )),

                    //Frame for button
                    SizedBox(
                      width: 100,

                      //Button to toggle listening
                      child: ElevatedButton(
                          onPressed: _toggleListening,
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              elevation: 60.0,
                              shadowColor: Colors.black,
                              side: const BorderSide(color: Colors.black),
                              backgroundColor: _isListening
                                  ? Colors.red
                                  : Colors.lightBlueAccent),
                          child: const Icon(Icons.mic)),
                    ),

                    //Frame for output text box
                    Container(
                        width: 475,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.6),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),

                        //Output text
                        child: Center(
                            child: Text(
                          _displayedAnswer,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        )))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
