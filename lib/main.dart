import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'habit_provider.dart';
import 'package:intl/intl.dart';
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
  _themeMode = themeMode;
  notifyListeners();

  }
  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => HabitsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'TaskMaster',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'neat',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'neat',
      ),
      home: TaskMaster(),
    );
  }
}
class MindfulnessExercises extends StatefulWidget {
  @override
  _MindfulnessExercisesState createState() => _MindfulnessExercisesState();
}

class _MindfulnessExercisesState extends State<MindfulnessExercises> {
  VideoPlayerController? _controller;
  int? _currentVideoIndex;

  final List<Map<String, String>> _videos = [
    {'title': 'Mindfulness Exercise-1', 'url': 'assets/videos/video1.mp4'},
    {'title': 'Mindfulness Exercise-2', 'url': 'assets/videos/mf2.mp4'},
    {'title': 'Mindfulness Exercise-3', 'url': 'assets/videos/mf3.mp4'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the first video by default
    if (_videos.isNotEmpty) {
      _initializeVideo(0);
    }
  }

  void _initializeVideo(int index) {
    if (_controller != null) {
      _controller!.dispose();
    }
    _controller = VideoPlayerController.asset(_videos[index]['url']!)
      ..initialize().then((_) {
        setState(() {
          _currentVideoIndex = index;
        });
        _controller!.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HabitTrackerHome()),
                      );
                    },
                    icon: Image.asset('assets/images/1.png', height: 30, width: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskMaster()),
                      );
                    },
                    icon: Image.asset('assets/images/tasks.png', height: 30, width: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PomodoroTimerScreen()),
                      );
                    },
                    icon: Image.asset('assets/images/2.png', height: 30, width: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MusicListScreen()),
                      );
                    },
                    icon: Image.asset('assets/images/3.png', height: 30, width: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MindfulnessExercisesList()),
                      );
                    },
                    icon: Image.asset('assets/images/4.png', height: 30, width: 30)),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
                VideoProgressIndicator(_controller!, allowScrubbing: true),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller!.value.isPlaying
                                ? _controller!.pause()
                                : _controller!.play();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.stop,
                          color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        ),
                        onPressed: () {
                          _controller!.seekTo(Duration.zero);
                          _controller!.pause();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 200,
                  width: 350,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: AppBar().preferredSize.height,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Text(
                    'Choose Exercise',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      fontSize: 35,
                      color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _videos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            _videos[index]['title']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                            ),
                          ),
                          selected: _currentVideoIndex == index,
                          onTap: () {
                            _initializeVideo(index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BreathingExercises extends StatefulWidget {
  @override
  _BreathingExercisesState createState() => _BreathingExercisesState();
}

class _BreathingExercisesState extends State<BreathingExercises> {
  VideoPlayerController? _controller;
  int? _currentVideoIndex;

  final List<Map<String, String>> _videos = [
    {'title': 'Breathing Exercise-1', 'url': 'assets/videos/b1.mp4'},
    {'title': 'Breathing Exercise-2', 'url': 'assets/videos/b2.mp4'},
    {'title': 'Breathing Exercise-3', 'url': 'assets/videos/video3.mp4'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the first video by default
    if (_videos.isNotEmpty) {
      _initializeVideo(0);
    }
  }

  void _initializeVideo(int index) {
    if (_controller != null) {
      _controller!.dispose();
    }
    _controller = VideoPlayerController.asset(_videos[index]['url']!)
      ..initialize().then((_) {
        setState(() {
          _currentVideoIndex = index;
        });
        _controller!.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HabitTrackerHome()),
                      );
                    },
                    icon: Image.asset('assets/images/1.png', height: 30, width: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskMaster()),
                      );
                    },
                    icon: Image.asset('assets/images/tasks.png', height: 30, width: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PomodoroTimerScreen()),
                      );
                    },
                    icon: Image.asset('assets/images/2.png', height: 30, width: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MusicListScreen()),
                      );
                    },
                    icon: Image.asset('assets/images/3.png', height: 30, width: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MindfulnessExercisesList()),
                      );
                    },
                    icon: Image.asset('assets/images/4.png', height: 30, width: 30)),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
                VideoProgressIndicator(_controller!, allowScrubbing: true),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller!.value.isPlaying
                                ? _controller!.pause()
                                : _controller!.play();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.stop,
                          color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        ),
                        onPressed: () {
                          _controller!.seekTo(Duration.zero);
                          _controller!.pause();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 200,
                  width: 350,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: AppBar().preferredSize.height,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Text(
                    'Choose Exercise',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      fontSize: 35,
                      color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _videos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            _videos[index]['title']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                            ),
                          ),
                          selected: _currentVideoIndex == index,
                          onTap: () {
                            _initializeVideo(index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BodyScanExercises extends StatefulWidget {
  @override
  _BodyScanExercisesState createState() => _BodyScanExercisesState();
}

class _BodyScanExercisesState extends State<BodyScanExercises> {
  VideoPlayerController? _controller;
  int? _currentVideoIndex;

  final List<Map<String, String>> _videos = [
    {'title': 'BodyScan Exercise-1', 'url': 'assets/videos/bs1.mp4'},
    {'title': 'BodyScan Exercise-2', 'url': 'assets/videos/video2.mp4'},
    {'title': 'BodyScan Exercise-3', 'url': 'assets/videos/bs3.mp4'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the first video by default
    if (_videos.isNotEmpty) {
      _initializeVideo(0); // Initialize the first video if available
    }
  }

  void _initializeVideo(int index) {
    if (_controller != null) {
      _controller!.dispose();
    }
    _controller = VideoPlayerController.asset(_videos[index]['url']!)
      ..initialize().then((_) {
        setState(() {
          _currentVideoIndex = index;
        });
        _controller!.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HabitTrackerHome()),
                      );
                    },
                    icon: Image.asset('assets/images/1.png', height: 30, width: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskMaster()),
                      );
                    },
                    icon: Image.asset('assets/images/tasks.png', height: 30, width: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PomodoroTimerScreen()),
                      );
                    },
                    icon: Image.asset('assets/images/2.png', height: 30, width: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MusicListScreen()),
                      );
                    },
                    icon: Image.asset('assets/images/3.png', height: 30, width: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MindfulnessExercisesList()),
                      );
                    },
                    icon: Image.asset('assets/images/4.png', height: 30, width: 30)),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
                VideoProgressIndicator(_controller!, allowScrubbing: true),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller!.value.isPlaying
                                ? _controller!.pause()
                                : _controller!.play();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.stop,
                          color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        ),
                        onPressed: () {
                          _controller!.seekTo(Duration.zero);
                          _controller!.pause();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 200,
                  width: 350,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: AppBar().preferredSize.height,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Text(
                    'Choose Exercise',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      fontSize: 35,
                      color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _videos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            _videos[index]['title']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                            ),
                          ),
                          selected: _currentVideoIndex == index,
                          onTap: () {
                            _initializeVideo(index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class MindfulnessExercisesList extends StatefulWidget {
  @override
  _MindfulnessExercisesListState createState() => _MindfulnessExercisesListState();
}

class _MindfulnessExercisesListState extends State<MindfulnessExercisesList> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HabitTrackerHome()),
                    );
                  },
                  icon: Image.asset('assets/images/1.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskMaster()),
                    );
                  },
                  icon: Image.asset('assets/images/tasks.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PomodoroTimerScreen()),
                    );
                  },
                  icon: Image.asset('assets/images/2.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MusicListScreen()),
                    );
                  },
                  icon: Image.asset('assets/images/3.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MindfulnessExercisesList()),
                    );
                  },
                  icon: Image.asset('assets/images/4.png', height: 30, width: 30),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Switch(
                        value: isDarkMode,
                        activeColor: Colors.yellowAccent,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Become Mindful",
                          style: TextStyle(
                            color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 12,
                      shadowColor: isDarkMode ? Colors.yellowAccent : Colors.grey,
                      backgroundColor: isDarkMode ? Colors.white : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Breathing Exercises',
                      style: TextStyle(
                        color: isDarkMode ? Colors.purpleAccent : Colors.yellowAccent,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BreathingExercises()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 12,
                      shadowColor: isDarkMode ? Colors.yellowAccent : Colors.grey,
                      backgroundColor: isDarkMode ? Colors.white : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Mindfulness Exercises',
                      style: TextStyle(
                        color: isDarkMode ? Colors.purpleAccent : Colors.yellowAccent,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MindfulnessExercises()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 12,
                      shadowColor: isDarkMode ? Colors.yellowAccent : Colors.grey,
                      backgroundColor: isDarkMode ? Colors.white : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'BodyScan Exercises',
                      style: TextStyle(
                        color: isDarkMode ? Colors.purpleAccent : Colors.yellowAccent,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BodyScanExercises()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class HabitTrackerHome extends StatefulWidget {
  @override
  _HabitTrackerHomeState createState() => _HabitTrackerHomeState();
}

class _HabitTrackerHomeState extends State<HabitTrackerHome> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HabitTrackerHome()),
                    );
                  },
                  icon: Image.asset('assets/images/1.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskMaster()),
                    );
                  },
                  icon: Image.asset('assets/images/tasks.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PomodoroTimerScreen()),
                    );
                  },
                  icon: Image.asset('assets/images/2.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MusicListScreen()),
                    );
                  },
                  icon: Image.asset('assets/images/3.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MindfulnessExercisesList()),
                    );
                  },
                  icon: Image.asset('assets/images/4.png', height: 30, width: 30),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Switch(
                        activeColor: Colors.yellowAccent,
                        value: isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Habit Tracker",
                          style: TextStyle(
                            color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 4,
                    color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shadowColor: isDarkMode ? Colors.purpleAccent : Colors.yellowAccent,
                      backgroundColor: isDarkMode ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: Text(
                      'Build Habits',
                      style: TextStyle(
                        color: isDarkMode ? Colors.purpleAccent : Colors.yellowAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BuildHabits()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shadowColor: isDarkMode ? Colors.purpleAccent : Colors.yellowAccent,
                      backgroundColor: isDarkMode ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: Text(
                      'Quit Habits',
                      style: TextStyle(
                        color: isDarkMode ? Colors.purpleAccent : Colors.yellowAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuitHabits()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shadowColor: isDarkMode ? Colors.purpleAccent : Colors.yellowAccent,
                      backgroundColor: isDarkMode ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: Text(
                      'Track Habits',
                      style: TextStyle(
                        color: isDarkMode ? Colors.purpleAccent : Colors.yellowAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrackHabits()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MusicListScreen extends StatefulWidget {
  @override
  _MusicListScreenState createState() => _MusicListScreenState();
}

class _MusicListScreenState extends State<MusicListScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  int? currentMusicIndex;

  List<Map<String, String>> songs = [
    {'title': 'Music 1', 'url': 'assets/music/s1.mp3'},
    {'title': 'Music 2', 'url': 'assets/music/s2.mp3'},
    {'title': 'Music 3', 'url': 'assets/music/s3.mp3'},
    {'title': 'Music 4', 'url': 'assets/music/s4.mp3'},
    {'title': 'Music 5', 'url': 'assets/music/s5.mp3'},
    {'title': 'Music 6', 'url': 'assets/music/s6.mp3'},
    {'title': 'Music 7', 'url': 'assets/music/s7.mp3'},
    {'title': 'Music 8', 'url': 'assets/music/s8.mp3'},
    {'title': 'Music 9', 'url': 'assets/music/s9.mp3'},
    {'title': 'Music 10', 'url': 'assets/music/s10.mp3'},
    {'title': 'Music 11', 'url': 'assets/music/s11.mp3'},
    {'title': 'Music 12', 'url': 'assets/music/s12.mp3'},
    {'title': 'Music 13', 'url': 'assets/music/s13.mp3'},
    {'title': 'Music 14', 'url': 'assets/music/s14.mp3'},
    {'title': 'Music 15', 'url': 'assets/music/s15.mp3'},
  ];

  void playMusic(String url) async {
    try {
      await audioPlayer.setAsset(url);
      audioPlayer.play();
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HabitTrackerHome()),
                    );
                  },
                  icon: Image.asset('assets/images/1.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskMaster()),
                    );
                  },
                  icon: Image.asset('assets/images/tasks.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PomodoroTimerScreen()),
                    );
                  },
                  icon: Image.asset('assets/images/2.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MusicListScreen()),
                    );
                  },
                  icon: Image.asset('assets/images/3.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MindfulnessExercisesList()),
                    );
                  },
                  icon: Image.asset('assets/images/4.png', height: 30, width: 30),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10), // Adjusted spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(
                  value: isDarkMode,
                  activeColor: Colors.yellowAccent,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Concentration Beats",
                    style: TextStyle(
                      color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Adjusted spacing
            Divider(
              thickness: 2,
              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                        title: Center(
                          child: Text(
                            songs[index]['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            currentMusicIndex = index;
                          });
                          playMusic(songs[index]['url']!);
                        },
                        selected: currentMusicIndex == index,
                      ),
                      Divider(
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        thickness: 1,
                        indent: 15,
                        endIndent: 15,
                      ),
                    ],
                  );
                },
              ),
            ),
            if (currentMusicIndex != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.pause,
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      ),
                      onPressed: () {
                        audioPlayer.pause();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.play_arrow,
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      ),
                      onPressed: () {
                        playMusic(songs[currentMusicIndex!]['url']!);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.stop,
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      ),
                      onPressed: () {
                        audioPlayer.stop();
                        setState(() {
                          currentMusicIndex = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PomodoroTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro Timer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: PomodoroTimerScreen(),
    );
  }
}

class PomodoroTimerScreen extends StatefulWidget {
  @override
  _PomodoroTimerScreenState createState() => _PomodoroTimerScreenState();
}

class _PomodoroTimerScreenState extends State<PomodoroTimerScreen> {
  static const int workTime = 25 * 60; // 25 minutes in seconds
  static const int breakTime = 5 * 60; // 5 minutes in seconds

  late int _currentTime;
  late bool _isRunning;
  late bool _isWorkTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  void _resetTimer() {
    setState(() {
      _currentTime = workTime;
      _isRunning = false;
      _isWorkTime = true;
    });
  }

  void _startTimer() {
    if (_isRunning) return;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentTime > 0) {
          _currentTime--;
        } else {
          _timer?.cancel();
          _isWorkTime = !_isWorkTime;
          _currentTime = _isWorkTime ? workTime : breakTime;
        }
      });
    });

    setState(() {
      _isRunning = true;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HabitTrackerHome()),
                    );
                  },
                  icon: Image.asset('assets/images/1.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskMaster()),
                    );
                  },
                  icon: Image.asset('assets/images/tasks.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PomodoroTimerScreen()),
                    );
                  },
                  icon: Image.asset('assets/images/2.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MusicListScreen()),
                    );
                  },
                  icon: Image.asset('assets/images/3.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MindfulnessExercisesList()),
                    );
                  },
                  icon: Image.asset('assets/images/4.png', height: 30, width: 30),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0), // Adjusted top padding for space below AppBar
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Pomodoro Timer",
                      style: TextStyle(
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(
                  thickness: 2,
                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                ),
              ],
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _isWorkTime ? 'Work Time' : 'Break Time',
                  style: TextStyle(
                    fontSize: 54,
                    color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                  ),
                ),
                Text(
                  _formatTime(_currentTime),
                  style: TextStyle(
                    fontSize: 68,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.purple : Colors.red, // Adjust button color based on theme
                      ),
                      onPressed: _isRunning ? null : _startTimer,
                      child: Text(
                        'Start',
                        style: TextStyle(
                          color: isDarkMode ? Colors.yellowAccent : Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.purple : Colors.red, // Adjust button color based on theme
                      ),
                      onPressed: _isRunning ? _pauseTimer : null,
                      child: Text(
                        'Pause',
                        style: TextStyle(
                          color: isDarkMode ? Colors.yellowAccent : Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.purple : Colors.red, // Adjust button color based on theme
                      ),
                      onPressed: _resetTimer,
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          color: isDarkMode ? Colors.yellowAccent : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Import Provider if you use it for theme
 // Make sure you import your ThemeProvider class
class TaskMaster extends StatefulWidget {
  @override
  _TaskMasterState createState() => _TaskMasterState();
}

class _TaskMasterState extends State<TaskMaster> {
  List<Map<String, Object>> tasks = [];
  List<Map<String, Object>> completedTasks = [];
  List<Map<String, Object>> importantTasks = [];
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? savedTasks = prefs.getStringList('tasks');
    final List<String>? savedCompletedTasks = prefs.getStringList('completedTasks');
    final List<String>? savedImportantTasks = prefs.getStringList('importantTasks');

    setState(() {
      if (savedTasks != null) {
        tasks = savedTasks.map((task) {
          final parts = task.split('|');
          return {
            'task': parts[0],
            'description': parts[1],
            'dueDate': DateTime.parse(parts[2]),
            'category': parts[3],
          };
        }).toList();
      }

      if (savedCompletedTasks != null) {
        completedTasks = savedCompletedTasks.map((task) {
          final parts = task.split('|');
          return {
            'task': parts[0],
            'description': parts[1],
            'dueDate': DateTime.parse(parts[2]),
            'category': parts[3],
          };
        }).toList();
      }

      if (savedImportantTasks != null) {
        importantTasks = savedImportantTasks.map((task) {
          final parts = task.split('|');
          return {
            'task': parts[0],
            'description': parts[1],
            'dueDate': DateTime.parse(parts[2]),
            'category': parts[3],
          };
        }).toList();
      }
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> savedTasks = tasks.map((task) {
      return '${task['task']}|${task['description']}|${(task['dueDate'] as DateTime).toIso8601String()}|${task['category']}';
    }).toList();

    final List<String> savedCompletedTasks = completedTasks.map((task) {
      return '${task['task']}|${task['description']}|${(task['dueDate'] as DateTime).toIso8601String()}|${task['category']}';
    }).toList();

    final List<String> savedImportantTasks = importantTasks.map((task) {
      return '${task['task']}|${task['description']}|${(task['dueDate'] as DateTime).toIso8601String()}|${task['category']}';
    }).toList();

    await prefs.setStringList('tasks', savedTasks);
    await prefs.setStringList('completedTasks', savedCompletedTasks);
    await prefs.setStringList('importantTasks', savedImportantTasks);
  }

  void _showTaskForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
        TextEditingController taskController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();
        DateTime selectedDate = DateTime.now();
        String selectedCategory = 'General';

        return AlertDialog(
          elevation: 3.0,
          backgroundColor: Colors.black,
          shadowColor: isDarkMode ? Colors.white : Colors.black,

          title: Text('Add a Task',
            textAlign: TextAlign.center,

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      labelStyle: TextStyle(
                          color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      )
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Task Description',
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        )
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    child: Text(
                      'Deadline : ${ DateFormat.yMMMd().format(selectedDate)}',
                      style: TextStyle(color: isDarkMode ? Colors.yellowAccent : Colors.purple),
                    ),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      }
                    },
                    items: <String>['General', 'Work', 'Personal']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: TextStyle(
                          color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        )),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                elevation: 1.0,
                shadowColor: Colors.white,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  setState(() {
                    tasks.add({
                      'task': taskController.text,
                      'description': descriptionController.text,
                      'dueDate': selectedDate,
                      'category': selectedCategory,
                    });
                    _saveTasks(); // Save tasks after adding
                  });
                  Navigator.of(context).pop(); // Close the dialog after adding the task
                }
              },
              style: ElevatedButton.styleFrom(
        elevation: 1.0,
        shadowColor: Colors.white,
        ),
              child: Text(
                'Add',
                style: TextStyle(
                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      completedTasks.add(tasks[index]);
      tasks.removeAt(index);
      _saveTasks();
    });
  }

  void _toggleTaskRemove(int index) {
    setState(() {
      tasks.removeAt(index);
      _saveTasks();
    });
  }

  void _toggleTaskImportant(int index) {
    setState(() {
      importantTasks.add(tasks[index]);
      tasks.removeAt(index);
      _saveTasks();
    });
  }

  void _undoTaskCompletion(int index) {
    setState(() {
      tasks.add(completedTasks[index]);
      completedTasks.removeAt(index);
      _saveTasks();
    });
  }

  void _toggleCompletedTaskRemove(int index) {
    setState(() {
      completedTasks.removeAt(index);
      _saveTasks();
    });
  }

  void _toggleCompletedTaskImportant(int index) {
    setState(() {
      importantTasks.add(completedTasks[index]);
      completedTasks.removeAt(index);
      _saveTasks();
    });
  }

  void _toggleImportantTaskCompletion(int index) {
    setState(() {
      completedTasks.add(importantTasks[index]);
      importantTasks.removeAt(index);
      _saveTasks();
    });
  }

  void _toggleImportantTaskRemove(int index) {
    setState(() {
      importantTasks.removeAt(index);
      _saveTasks();
    });
  }

  void _undoTaskImportant(int index) {
    setState(() {
      tasks.add(importantTasks[index]);
      importantTasks.removeAt(index);
      _saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitTrackerHome(),
                ),
              );
            },
            icon: Image.asset('assets/images/1.png'),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PomodoroTimerScreen(),
                ),
              );
            },
            icon: Image.asset('assets/images/2.png'),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicListScreen(),
                ),
              );
            },
            icon: Image.asset('assets/images/3.png'),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MindfulnessExercisesList(),
                ),
              );
            },
            icon: Image.asset('assets/images/4.png'),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Image.asset(
            'assets/images/logo.png',
            height: 120,
            width: 120,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Column(
              children: [
                Row(
                  children: [
                    Switch(
                      activeColor: Colors.yellowAccent,
                      value: isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          isDarkMode = value;
                          themeProvider.setThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "Task Manager",
                        style: TextStyle(
                          color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  ],
                ),
                Divider(
                  thickness: 2,
                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (tasks.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          '                       Tasks',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                          ),
                        ),

                      ),
                      Divider(
                        thickness: 2,
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return ListTile(
                            title: Text(
                              task['task'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                              ),
                            ),
                            subtitle: Text('Deadline: ${DateFormat.yMMMd().format(task['dueDate'] as DateTime)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check,  color: isDarkMode ? Colors.yellowAccent : Colors.purple,),
                                  onPressed: () => _toggleTaskCompletion(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,  color: isDarkMode ? Colors.yellowAccent : Colors.purple,),
                                  onPressed: () => _toggleTaskRemove(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.star,  color: isDarkMode ? Colors.yellowAccent : Colors.purple,),
                                  onPressed: () => _toggleTaskImportant(index),
                                ),
                              ],
                            ),
                            onLongPress: () => _toggleTaskRemove(index),
                          );

                        },

                      ),
                      Divider(
                        thickness: 2,
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      ),

                    ],
                  ),
                if (completedTasks.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          '            Completed Tasks',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                          ),
                        ),

                      ),
                      Divider(
                        thickness: 2,
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: completedTasks.length,
                        itemBuilder: (context, index) {
                          final task = completedTasks[index];
                          return ListTile(
                            title: Text(
                              task['task'] as String,
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                              ),
                            ),
                            subtitle: Text('Deadline: ${DateFormat.yMMMd().format(task['dueDate'] as DateTime)}',style: TextStyle( decoration: TextDecoration.lineThrough,),),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.undo, color: isDarkMode ? Colors.yellowAccent : Colors.purple,),
                                  onPressed: () => _undoTaskCompletion(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: isDarkMode ? Colors.yellowAccent : Colors.purple,),
                                  onPressed: () => _toggleCompletedTaskRemove(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.star, color: isDarkMode ? Colors.yellowAccent : Colors.purple,),
                                  onPressed: () => _toggleCompletedTaskImportant(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Divider(
                        thickness: 2,
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      ),
                    ],
                  ),
                if (importantTasks.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          '             Important Tasks',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                          ),
                        ),

                      ),
                      Divider(
                        thickness: 2,
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: importantTasks.length,
                        itemBuilder: (context, index) {
                          final task = importantTasks[index];
                          return ListTile(
                            title: Text(
                              task['task'] as String,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                              ),
                            ),
                            subtitle: Text('Due Date: ${DateFormat.yMMMd().format(task['dueDate'] as DateTime)}',style: TextStyle( decoration: TextDecoration.underline,)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check,      color: isDarkMode ? Colors.yellowAccent : Colors.purple,),
                                  onPressed: () => _toggleImportantTaskCompletion(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,      color: isDarkMode ? Colors.yellowAccent : Colors.purple,),
                                  onPressed: () => _toggleImportantTaskRemove(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.undo,      color: isDarkMode ? Colors.yellowAccent : Colors.purple,),
                                  onPressed: () => _undoTaskImportant(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Divider(
                        thickness: 2,
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 75.0,
        width: 75.0,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: _showTaskForm,
          shape: const CircleBorder(),
          child: Icon(
            Icons.add_task_outlined,
            size: 70,
            color: isDarkMode ? Colors.yellowAccent : Colors.purple,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// Make sure you import ThemeProvider if used

class BuildHabits extends StatefulWidget {
  @override
  _BuildHabitsState createState() => _BuildHabitsState();
}

class _BuildHabitsState extends State<BuildHabits> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HabitsProvider>(context, listen: false).loadHabits();
    });
  }

  void _showHabitForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
        TextEditingController habitController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();

        return AlertDialog(
          title: Text('Add a Habit',
              textAlign: TextAlign.center,
              style: TextStyle(

                  color: isDarkMode ? Colors.yellowAccent : Colors.purple)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: habitController,
                decoration: InputDecoration(
                  labelText: 'Habit Name',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
          actions: [
            Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shadowColor: isDarkMode?Colors.yellowAccent:Colors.purpleAccent,
                      ),
                      onPressed: () {
                        if (habitController.text.isNotEmpty) {
                          Provider.of<HabitsProvider>(context, listen: false).addHabit({
                            'habit': habitController.text,
                            'description': descriptionController.text,
                          });
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text('Add',
                          style: TextStyle(
                              color: isDarkMode ? Colors.yellowAccent : Colors.purple)),
                    ),
                    ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shadowColor: isDarkMode?Colors.yellowAccent:Colors.purpleAccent,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel',
                          style: TextStyle(
                              color: isDarkMode ? Colors.yellowAccent : Colors.purple)),
                    ),],
                )


            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final habitsProvider = Provider.of<HabitsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: null,
        actions: [

          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskMaster()),
                );
              },
              icon: Image.asset('assets/images/1.png')),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PomodoroTimerScreen()),
                );
              },
              icon: Image.asset('assets/images/2.png')),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MusicListScreen()),
                );
              },
              icon: Image.asset('assets/images/3.png')),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MindfulnessExercisesList()),
                );
              },
              icon: Image.asset('assets/images/4.png')),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Image.asset(
            'assets/images/logo.png',
            height: 120,
            width: 120,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 05, left: 5),
            child: Text(
              "Build Habits",
              style: TextStyle(
                color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            thickness: 5.0,
            color: isDarkMode ? Colors.yellowAccent : Colors.purple,
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: (habitsProvider.habits.isEmpty &&
                habitsProvider.completedHabits.isEmpty &&
                habitsProvider.importantHabits.isEmpty)
                ? Center(
              child: Text(
                'No Habits Added Yet, Add a new habit.',
                style: TextStyle(
                  fontSize: 44,
                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                ),
                textAlign: TextAlign.center,
              ),
            )
                : ListView(
              children: [
                Text(
                  "Current Habits",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: isDarkMode ? Colors.yellowAccent : Colors.purple,
                    color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (habitsProvider.habits.isNotEmpty)
                  ...habitsProvider.habits.map((habit) {
                    int index = habitsProvider.habits.indexOf(habit);
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              habit['habit']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.done,
                                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                                ),
                                onPressed: () {
                                  habitsProvider.completeHabit(index);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                                ),
                                onPressed: () {
                                  habitsProvider.removeHabit(index);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Text(habit['description']!),
                    );
                  }).toList(),
                Divider(
                  thickness: 5.0,
                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                  indent: 20,
                  endIndent: 20,
                ),
                if (habitsProvider.completedHabits.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Completed Habits",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...habitsProvider.completedHabits.map((habit) {
                    int index = habitsProvider.completedHabits.indexOf(habit);
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              habit['habit']!,
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.undo,
                                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                                ),
                                onPressed: () {
                                  habitsProvider.undoHabitCompletion(index);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                                ),
                                onPressed: () {
                                  habitsProvider.removeCompletedHabit(index);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Text(habit['description']!),
                    );
                  }).toList(),
                ],
                Divider(
                  thickness: 5.0,
                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            ),
          ),
        ],
      ),



      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 26.0), // Adds bottom padding
        child: FloatingActionButton(
          backgroundColor: isDarkMode ? Colors.black : Colors.white, // Adjust background color based on theme
          onPressed: _showHabitForm,
          shape: const CircleBorder(),
          child: Icon(
            Icons.add_task_outlined,
            size: 50,
            color: isDarkMode ? Colors.yellowAccent : Colors.purple, // Icon color should contrast with background
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
class QuitHabits extends StatefulWidget {
  @override
  _QuitHabitsState createState() => _QuitHabitsState();
}

class _QuitHabitsState extends State<QuitHabits> {
  void _showHabitForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
        TextEditingController habitController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();

        return AlertDialog(
          title: Text(
            'Add a Habit',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: habitController,
                decoration: InputDecoration(
                  labelText: 'Habit Name',
                ),
              ),
              SizedBox(height: 16), // Add spacing between fields
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.yellowAccent : Colors.purple,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.yellowAccent : Colors.purple,
              ),
              onPressed: () {
                if (habitController.text.isNotEmpty) {
                  Provider.of<HabitsProvider>(context, listen: false).addHabitQuit({
                    'habit': habitController.text,
                    'description': descriptionController.text,
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final habitsProvider = Provider.of<HabitsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskMaster()),
              );
            },
            icon: Image.asset('assets/images/1.png'),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PomodoroTimerScreen()),
              );
            },
            icon: Image.asset('assets/images/2.png'),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MusicListScreen()),
              );
            },
            icon: Image.asset('assets/images/3.png'),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MindfulnessExercisesList()),
              );
            },
            icon: Image.asset('assets/images/4.png'),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.png',
            height: 80,
            width: 80,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Quit Habits",
              style: TextStyle(
                color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Divider(
              thickness: 5.0,
              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: habitsProvider.habitsQuit.isEmpty &&
                  habitsProvider.completedHabitsQuit.isEmpty &&
                  habitsProvider.importantHabitsQuit.isEmpty
                  ? Center(
                child: Text(
                  'No Quit Habits Added Yet, Click on `+` to add.',
                  style: TextStyle(
                    fontSize: 24,
                    color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Current Habits",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (habitsProvider.habitsQuit.isNotEmpty) ...[
                    ...habitsProvider.habitsQuit.map((habit) {
                      int index = habitsProvider.habitsQuit.indexOf(habit);
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                habit['habit']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.done, color: isDarkMode ? Colors.yellowAccent : Colors.purple),
                              onPressed: () {
                                habitsProvider.completeHabitQuit(index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: isDarkMode ? Colors.yellowAccent : Colors.purple),
                              onPressed: () {
                                habitsProvider.removeHabitQuit(index);
                              },
                            ),
                          ],
                        ),
                        subtitle: Text(habit['description']!),
                      );
                    }).toList(),
                  ],
                  Divider(
                    thickness: 5.0,
                    color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Completed Habits",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (habitsProvider.completedHabitsQuit.isNotEmpty) ...[
                    ...habitsProvider.completedHabitsQuit.map((habit) {
                      int index = habitsProvider.completedHabitsQuit.indexOf(habit);
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                habit['habit']!,
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.undo, color: isDarkMode ? Colors.yellowAccent : Colors.purple),
                              onPressed: () {
                                habitsProvider.undoHabitCompletionQuit(index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: isDarkMode ? Colors.yellowAccent : Colors.purple),
                              onPressed: () {
                                habitsProvider.removeCompletedHabitQuit(index);
                              },
                            ),
                          ],
                        ),
                        subtitle: Text(habit['description']!),
                      );
                    }).toList(),
                  ],
                  Divider(
                    thickness: 5.0,
                    color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showHabitForm,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        foregroundColor: isDarkMode ? Colors.yellowAccent : Colors.purple,
        shape: const CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
 // Adjust this import based on your actual file structure

class TrackHabits extends StatefulWidget {
  @override
  _TrackHabitsState createState() => _TrackHabitsState();
}

class _TrackHabitsState extends State<TrackHabits> {
  void _showTaskForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
        TextEditingController taskController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();

        return AlertDialog(
          title: Text(
            'Add Habit',
            style: TextStyle(
              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  labelText: 'Habit Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  Provider.of<HabitsProvider>(context, listen: false).addHabit({
                    'habit': taskController.text,
                    'description': descriptionController.text,
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'Add',
                style: TextStyle(
                  color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final habitsProvider = Provider.of<HabitsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjusted padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HabitTrackerHome()),
                    );
                  },
                  icon: Image.asset('assets/images/1.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskMaster()),
                    );
                  },
                  icon: Image.asset('assets/images/tasks.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PomodoroTimerScreen()),
                    );
                  },
                  icon: Image.asset('assets/images/2.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MusicListScreen()),
                    );
                  },
                  icon: Image.asset('assets/images/3.png', height: 30, width: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MindfulnessExercisesList()),
                    );
                  },
                  icon: Image.asset('assets/images/4.png', height: 30, width: 30),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Habits to Build",
              style: TextStyle(
                color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Divider(
              thickness: 2,
              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: habitsProvider.habits.isEmpty
                  ? Center(
                child: Text(
                  'No Habits to Build',
                  style: TextStyle(
                    fontSize: 24,
                    color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView(
                children: habitsProvider.habits.map((habit) {
                  int index = habitsProvider.habits.indexOf(habit);
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            habit['habit']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.done, color: isDarkMode ? Colors.yellowAccent : Colors.purple),
                          onPressed: () {
                            habitsProvider.completeHabit(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: isDarkMode ? Colors.yellowAccent : Colors.purple),
                          onPressed: () {
                            habitsProvider.removeHabit(index);
                          },
                        ),
                      ],
                    ),
                    subtitle: Text(habit['description']!),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Habits to Quit",
              style: TextStyle(
                color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Divider(
              thickness: 2,
              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: habitsProvider.habitsQuit.isEmpty
                  ? Center(
                child: Text(
                  'No Habits to Quit',
                  style: TextStyle(
                    fontSize: 24,
                    color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView(
                children: habitsProvider.habitsQuit.map((habit) {
                  int index = habitsProvider.habitsQuit.indexOf(habit);
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            habit['habit']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: isDarkMode ? Colors.yellowAccent : Colors.purple,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.done, color: isDarkMode ? Colors.yellowAccent : Colors.purple),
                          onPressed: () {
                            habitsProvider.completeHabitQuit(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: isDarkMode ? Colors.yellowAccent : Colors.purple),
                          onPressed: () {
                            habitsProvider.removeHabitQuit(index);
                          },
                        ),
                      ],
                    ),
                    subtitle: Text(habit['description']!),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16), // Space for better visual balance
          ],
        ),
      ),

    );
  }
}
