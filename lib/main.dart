
import 'package:flutter/material.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'firebase_options.dart';
  import 'package:firebase_database/firebase_database.dart';
  import 'package:just_audio/just_audio.dart';


  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({Key? key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'FireApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
    }
  }

  class MyHomePage extends StatefulWidget {
    const MyHomePage({Key? key, required this.title});

    final String title;

    @override
    State<MyHomePage> createState() => _MyHomePageState();
  }

  class _MyHomePageState extends State<MyHomePage> {
  bool fireToggle = false;

  // final fireStartPlayer = AudioPlayer();
  final music = AudioPlayer();

  DatabaseReference dbref = FirebaseDatabase.instance.ref('posts/toggleKey/toggleFire');

  @override
  void initState() {
    super.initState();
    listenToggle();
  }


  Future<void> listenToggle() async {
    dbref.onValue.listen((DatabaseEvent event){
      setState(() {
        fireToggle = (event.snapshot.value == 'true');
      });
    });
  }

  Future<void> writeNewPost(bool val) async {
    await dbref.set(val.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'For Esa, Forever Glow',
            ),
            GestureDetector(
              onDoubleTap: () async {
                setState(() {
                  fireToggle = !fireToggle;
                  writeNewPost(fireToggle);
                });
                if(fireToggle){
                  // await fireStartPlayer.play(AssetSource('fireOn.mp3'));
                  // fireStartPlayer.setReleaseMode(ReleaseMode.loop);
                  // await music.setAsset('assets/fireOn.mp3');
                  // await music.setLoopMode(LoopMode.one);
                  // music.play();

                  final playlist = ConcatenatingAudioSource(
                    useLazyPreparation: true,
                    shuffleOrder: DefaultShuffleOrder(),
                    children: [
                      AudioSource.asset('assets/audiomass-output.mp3'),
                      AudioSource.asset('assets/audiomass-output.mp3'),
                      AudioSource.asset('assets/audiomass-output.mp3'),
                    ],
                  );

                  await music.setAudioSource(playlist, initialIndex: 0, initialPosition: Duration.zero);
                  await music.setLoopMode(LoopMode.all);
                  music.play();
                }else{
                  music.stop();
                }
              },
              child: Visibility(
                visible: fireToggle,
                replacement: Image.asset(
                  'assets/noCandle.png',
                  width: 200,
                  height: 200,
                ),
                child: Image.asset(
                  'assets/9PrD.gif',
                  width: 300,
                  height: 300,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
