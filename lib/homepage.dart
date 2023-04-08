import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterTts flutterTts = FlutterTts();
  final player = AudioPlayer(); // Create a player

  List someImages = [];
  String imagePath = "";
  List topList = [];
  List answerList = [];
  List bottomList = [];
  bool loadImg = false;
  Map map = {};
  String imageName = "";
  bool showerror = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initImages();
  }

  Future initImages() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('.webp'))
        .toList();

    setState(() {
      someImages = imagePaths;
      // print("SomeImages = $someImages \nSomeImagesLength = ${someImages.length}");
      int randomNumber = Random().nextInt(someImages.length);
      print("RandomNumber = $randomNumber");
      imagePath = someImages[randomNumber];
      print("ImagePath = $imagePath");
      imageName = imagePath.split("/")[1].split("\.")[0];
      print("ImageName = $imageName");
      topList = List.filled(imageName.length, "");
      print("TopList $topList TopList Length = ${topList.length}");
      answerList = imageName.split("");
      print(
          "AnswerList = $answerList AnswerList Length = ${answerList.length}");
      String abcd = "abcdefghijklmnopqrstuvwxyz";
      List alphabetList = abcd.split("");
      alphabetList.shuffle();
      print("AlphabetList = $alphabetList");
      bottomList = alphabetList.getRange(0, 10 - topList.length).toList();
      bottomList.addAll(answerList);
      bottomList.shuffle();
      print(
          "BottomList = $bottomList BottomList Length = ${bottomList.length}");
      loadImg = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    double statusbarHeight = MediaQuery.of(context).padding.top;
    double bodyHeight = totalHeight - statusbarHeight;
    return loadImg
        ? SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: bodyHeight * 0.2,
                    child: Text(
                      "Choose correct word",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    height: bodyHeight * 0.5,
                    decoration: BoxDecoration(
                      // color: Colors.red.withOpacity(0.5),
                      image: DecorationImage(
                        image: AssetImage("${imagePath}"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: bodyHeight * 0.01,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(12),
                    height: bodyHeight * 0.1,
                    // color: Colors.green.withOpacity(0.5),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: topList.length,
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1, crossAxisCount: 1),
                      itemBuilder: (context, index) {
                        if (topList[index] == answerList[index] &&
                            topList[index] != "") {
                          return InkWell(
                            onTap: () {
                              player.setAsset("popaudio/audiosss.wav");
                              setState(() {
                                if (topList.isNotEmpty) {
                                  player.play();
                                  bottomList[map[index]] = topList[index];
                                  topList[index] = "";
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "${topList[index].toString().toUpperCase()}",
                                style: TextStyle(fontSize: 20),
                              ),
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(7)),
                            ),
                          );
                        } else if (topList[index] != answerList[index] &&
                            topList[index] != "") {
                          return InkWell(
                            onTap: () {
                              player.setAsset("popaudio/audiosss.wav");
                              setState(() {
                                if (topList.isNotEmpty) {
                                  player.setAsset("popaudio/audiosss.wav");
                                  bottomList[map[index]] = topList[index];
                                  topList[index] = "";
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "${topList[index].toString().toUpperCase()}",
                                style: TextStyle(fontSize: 20),
                              ),
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(7)),
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (topList.isNotEmpty) {
                                  bottomList[map[index]] = topList[index];
                                  topList[index] = "";
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "${topList[index].toString().toUpperCase()}",
                                style: TextStyle(fontSize: 20),
                              ),
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(7)),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: bodyHeight * 0.03,
                  ),
                  Container(
                    width: totalWidth,
                    alignment: Alignment.center,
                    height: bodyHeight * 0.16,
                    // color: Colors.blue.withOpacity(0.5),
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 12,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        if (index == 10) {
                          return Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: () {
                                flutterTts.speak("${imageName}");
                              },
                              icon: FaIcon(
                                Icons.lightbulb_rounded,
                                color: Colors.red,
                              ),
                            ),
                          );
                        } else if (index == 11) {
                          return Container(
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: () async {
                                  for (int i = 0; i < answerList.length; i++) {
                                    await Future.delayed(Duration(seconds: 2))
                                        .then((value) => flutterTts
                                            .speak("${answerList[i]}"));
                                  }
                                },
                                icon: FaIcon(Icons.lightbulb_rounded),
                                color: Colors.green,
                              ));
                        } else {
                          return InkWell(
                            onTap: () {
                              player.setAsset("popaudio/popup.mp3");
                              setState(() {
                                for (int i = 0; i < topList.length; i++) {
                                  if (topList[i].isEmpty) {
                                    player.play();
                                    topList[i] = bottomList[index];
                                    bottomList[index] = "";
                                    map[i] = index;
                                    // print("Map = ${map}");
                                  }
                                }
                                if (topList.toString() ==
                                    answerList.toString()) {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return HomePage();
                                    },
                                  ));
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(3),
                              child: Text(
                                "${bottomList[index].toString().toUpperCase()}",
                                style: TextStyle(fontSize: 20),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(7)),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
