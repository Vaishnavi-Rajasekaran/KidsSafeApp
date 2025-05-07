  import 'package:flutter/material.dart';
  import 'package:url_launcher/url_launcher.dart';
  import 'chat_page.dart';
  import 'todo_page.dart';
  import 'learning_mode_page.dart';

  void main() {
    runApp(KidSafeApp());
  }

  class KidSafeApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'KidSafe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xff03045e), // Coral Red
          scaffoldBackgroundColor: Color(0xFFE1E8E8), // Light Cream
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF03045e),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff118496), // Dusty Rose
              foregroundColor: Colors.white,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Color(0xffb1cdd3), // Soft Peach
            border: OutlineInputBorder(),
          ),
        ),
        home: MainNavigationPage(),
      );
    }
  }

  class MainNavigationPage extends StatefulWidget {
    @override
    _MainNavigationPageState createState() => _MainNavigationPageState();
  }

  class _MainNavigationPageState extends State<MainNavigationPage> {
    int _currentIndex = 0;

    final List<Widget> _pages = [
      URLLauncherPage(),
      ChatPage(),
      ToDoHomePage(),
      LearningModePage(),
    ];

    final List<String> _titles = [
      "Web Search",
      "Messages",
      "To-Do List",
      "Learning Mode",
    ];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_titles[_currentIndex]),
          centerTitle: true,
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Color(0xFFC5CBCB), // Muted Lavender
          backgroundColor: Color(0xFF03045e), // Dusty Rose
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Web Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              label: 'To-Do',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Learn',
            ),
          ],
        ),
      );
    }
  }

  // Page 1: Web Search
  class URLLauncherPage extends StatelessWidget {
    final TextEditingController _controller = TextEditingController();

    final List<String> blockedUrls = [
      'example1.com',
      'example2.com',
      'badsite.com',
      'inappropriate.com',
      'adultcontent.com',
    ];

    void _launchURL(BuildContext context) async {
      String inputUrl = _controller.text.trim();

      if (!inputUrl.startsWith('http://') && !inputUrl.startsWith('https://')) {
        inputUrl = 'https://$inputUrl';
      }

      Uri uri = Uri.parse(inputUrl);
      String domain = uri.host.toLowerCase();

      bool isBlocked = blockedUrls.any((blocked) => domain.contains(blocked));

      if (isBlocked) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ URL Blocked for Child Safety')),
        );
      } else {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch URL')),
          );
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter URL',
              ),
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () => _launchURL(context),
              icon: Icon(Icons.search),
              label: Text('Search Safely'),
            ),
          ],
        ),
      );
    }
  }
