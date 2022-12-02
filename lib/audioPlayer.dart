import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MyAudioPlayer extends StatefulWidget {
  final String title;
  final String chapter;
  final String audioLink;
  final String imageLink;
  const MyAudioPlayer(
      {super.key,
      required this.title,
      required this.audioLink,
      required this.imageLink,
      required this.chapter});

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  /// For clarity, I added the terms compulsory and optional to certain sections
  /// to maintain clarity as to what is really needed for a functioning audio player
  /// and what is added for further interaction.
  ///
  /// 'Compulsory': A functioning audio player with:
  ///             - Play/Pause button
  ///
  /// 'Optional': A functioning audio player with:
  ///             - Play/Pause button
  ///             - time stamps for progress and duration
  ///             - slider to jump within the audio file
  ///
  /// Compulsory
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.PAUSED;
  String? url;

  /// Optional
  int timeProgress = 0;
  int audioDuration = 0;

  /// Optional
  Widget slider() {
    return SizedBox(
      child: Slider.adaptive(
          mouseCursor: MouseCursor.defer,
          activeColor: Colors.white,
          inactiveColor: Color.fromARGB(255, 152, 76, 211),
          value: timeProgress.toDouble(),
          max: audioDuration.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      url = widget.audioLink;
    });

    /// Compulsory
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    });

    /// Optional
    audioPlayer.setUrl(
        url!); // Triggers the onDurationChanged listener and sets the max duration string
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inSeconds;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration position) async {
      setState(() {
        timeProgress = position.inSeconds;
      });
    });
    playMusic();
  }

  /// Compulsory
  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  /// Compulsory
  playMusic() async {
    // Add the parameter "isLocal: true" if you want to access a local file
    await audioPlayer.play(url!);
  }

  /// Compulsory
  pauseMusic() async {
    await audioPlayer.pause();
  }

  /// Optional
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer
        .seek(newPos); // Jumps to the given position within the audio file
  }

  void fastforward(Duration sec) {}

  /// Optional
  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.chapter)),
      body: Container(
          color: Color.fromRGBO(112, 5, 195, 1),
          child: Column(
            children: [
              /// Compulsory
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  widget.imageLink,
                ),
              ),
              // audioPlayerState != PlayerState.PLAYING
              //     ? SizedBox(
              //         child: Image.network(
              //           'https://w7.pngwing.com/pngs/249/385/png-transparent-music-icon-music-icon-music-material-round-icon.png',
              //           height: 180,
              //           width: MediaQuery.of(context).size.width,
              //         ),
              //       )
              //     : Image.network(
              //         'https://cdn.dribbble.com/users/746306/screenshots/4639102/wave_sound.gif',
              //         height: 180,
              //         width: MediaQuery.of(context).size.width),

              /// Optional
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 100,
                child: Marquee(
                  text: widget.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .merge(TextStyle(color: Colors.white)),
                  blankSpace: 40,
                  scrollAxis: Axis.horizontal,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width, child: slider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      getTimeString(timeProgress),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      getTimeString(audioDuration),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.shuffle_outlined,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {
                          // seekToSec(-10);
                        },
                        icon: Icon(
                          Icons.fast_rewind,
                          color: Colors.white,
                        )),
                    InkWell(
                      onTap: () {
                        audioPlayerState == PlayerState.PLAYING
                            ? pauseMusic()
                            : playMusic();
                      },
                      child: Container(
                          height: 100,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 152, 76, 211),
                          ),
                          child: Icon(
                            audioPlayerState == PlayerState.PLAYING
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40,
                          )),
                    ),
                    // IconButton(
                    //     color: Colors.green,
                    //     iconSize: 50,
                    //     onPressed: () {
                    //       audioPlayerState == PlayerState.PLAYING
                    //           ? pauseMusic()
                    //           : playMusic();
                    //     },
                    //     icon: Icon(audioPlayerState == PlayerState.PLAYING
                    //         ? Icons.pause_rounded
                    //         : Icons.play_arrow_rounded)),
                    IconButton(
                        onPressed: () {
                          // seekToSec(10);
                        },
                        icon: Icon(
                          Icons.fast_forward,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.list,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
