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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 700,
                width: 600,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.amber,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/zfold5.png", fit: BoxFit.contain),
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: const Text('Samsung Galaxy Z Fold 5'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _toggleListening,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isListening ? Colors.red : Colors.amber,
                        ),
                        child: Text(
                          _isListening ? 'Stop Listening' : 'Start Listening',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Recognized Speech:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  _recognizedSpeech,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Displayed Answer:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  _displayedAnswer,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
