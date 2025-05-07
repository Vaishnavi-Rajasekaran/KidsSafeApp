import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning Mode',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LearningModePage(),
    );
  }
}

class LearningModePage extends StatefulWidget {
  @override
  _LearningModePageState createState() => _LearningModePageState();
}

class _LearningModePageState extends State<LearningModePage> {
  int studyTimer = 2;
  bool isStudying = false;
  Timer? timer;

  List<Map<String, String>> educationalLinks = [
    {
      'title': 'Khan Academy',
      'url': 'https://www.khanacademy.org',
      'description': 'Free educational resources for all subjects.'
    },
    {
      'title': 'National Geographic Kids',
      'url': 'https://kids.nationalgeographic.com',
      'description': 'Explore the world with fun articles and games.'
    },
    {
      'title': 'BBC Bitesize',
      'url': 'https://www.bbc.co.uk/bitesize',
      'description': 'Interactive lessons and revision resources.'
    },
  ];

  List<Map<String, String>> educationalVideos = [
    {
      'title': 'Maths Videos',
      'url': 'https://www.youtube.com/watch?v=8l9S9xnEnYw',
      'description': 'Learn math concepts with fun videos.'
    },
    {
      'title': 'Science Experiments',
      'url': 'https://www.youtube.com/watch?v=8Yyovrs9fHM',
      'description': 'Discover exciting science experiments.'
    },
  ];

  String wordOfTheDay = 'Cognition';
  String wordDefinition =
      'The mental action or process of acquiring knowledge and understanding.';

  void startStudyTimer() {
    if (isStudying) {
      setState(() {
        isStudying = false;
      });
      timer?.cancel();
    } else {
      setState(() {
        isStudying = true;
      });
      timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
        setState(() {
          if (studyTimer > 0) {
            studyTimer--;
          } else {
            timer?.cancel();
            isStudying = false;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Study Time Over!'),
                  content: Text(
                      'Great job! Take a break or proceed to the next task.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Okay'),
                    ),
                  ],
                );
              },
            );
          }
        });
      });
    }
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildCard(String title, IconData icon, Widget child) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.indigo),
                SizedBox(width: 10),
                Text(title,
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
            SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildCard(
              'Study Timer',
              Icons.timer,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time left: $studyTimer minute(s)',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: startStudyTimer,
                    icon: Icon(isStudying ? Icons.stop : Icons.play_arrow),
                    label: Text(isStudying
                        ? 'Stop Study Session'
                        : 'Start Study Session'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isStudying ? Colors.red : Colors.indigo),
                  ),
                ],
              ),
            ),

            buildCard(
              'Educational Websites',
              Icons.language,
              Column(
                children: educationalLinks.map((item) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item['title']!),
                    subtitle: Text(item['description']!),
                    trailing: Icon(Icons.open_in_new),
                    onTap: () => _launchURL(item['url']!),
                  );
                }).toList(),
              ),
            ),

            buildCard(
              'Educational Videos',
              Icons.ondemand_video,
              Column(
                children: educationalVideos.map((item) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item['title']!),
                    subtitle: Text(item['description']!),
                    trailing: Icon(Icons.play_circle_fill),
                    onTap: () => _launchURL(item['url']!),
                  );
                }).toList(),
              ),
            ),

            buildCard(
              'Word of the Day',
              Icons.lightbulb_outline,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(wordOfTheDay,
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(wordDefinition, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            buildCard(
              'Daily Learning Tip',
              Icons.tips_and_updates,
              Text(
                'Stay hydrated and take small breaks between study sessions!',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
