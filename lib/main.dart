import 'package:flutter/material.dart';
import 'dart:math';
import 'package:langchain_openai/langchain_openai.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //int count = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 135, 190, 213),
          title: const Text('Color Fortune Generator'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //GenerateColorBox().build(context);
            setState(() {
              //count++;
            });
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: 1,
          itemBuilder: (_, index) {
            return GenerateColorBox();
          },
        ),
      ),
    );
  }
}

Color randomColor() {
  var displayColor = 0xFFFFFFFF & Random().nextInt(0xFFFFFFFF);
  return Color(displayColor);
}

class GenerateColorBox extends StatelessWidget {
  GenerateColorBox({super.key});

  final Color displayColor = Color(0xFFFFFFFF & Random().nextInt(0xFFFFFFFF));
  late final int dAlpha = displayColor.alpha;
  late final int dR = displayColor.red;
  late final int dG = displayColor.green;
  late final int dB = displayColor.blue;
  late final String colorString = 'R:$dR, G:$dG, B:$dB, a:$dAlpha';
  late final String colorEmotion = getColorEmotion(colorString).toString();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getColorEmotion(colorString),
      builder: (context, snapshot) {
        var emotionText = snapshot.data;
        return Container(
          padding: const EdgeInsets.all(24),
          color: displayColor,
          width: 500,
          height: 500,
          child: Center(
            child: Text(
              '$colorString: $emotionText',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }
}

Future<String> getColorEmotion(String whichColor) {
  // replace with your api key
  String apiKey = "apiKey";

  String whichColorStr = whichColor.toString();
  final llm = OpenAI(apiKey: apiKey, maxTokens: 128);
  final result = llm.call(
      "Generate a random fortune cookie fortune using the $whichColorStr color as inspiration. Don't include the color in your response.");
  return result;
  //print(result);
}
