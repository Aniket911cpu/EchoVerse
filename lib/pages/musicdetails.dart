import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:echoverse/pages/home.dart';
import 'package:echoverse/utils/color.dart';
import 'package:echoverse/utils/musicmanager.dart';
import 'package:echoverse/utils/utils.dart';
import 'package:echoverse/widget/musicutils.dart';
import 'package:echoverse/widget/myimage.dart';
import 'package:echoverse/widget/mynetworkimg.dart';
import 'package:echoverse/widget/mytext.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';
import 'package:text_scroll/text_scroll.dart';

AudioPlayer audioPlayer = AudioPlayer();

Stream<PositionData> get positionDataStream {
  return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero))
      .asBroadcastStream();
}

final ValueNotifier<double> playerExpandProgress =
    ValueNotifier(playerMinHeight);

final MiniplayerController controller = MiniplayerController();

class MusicDetails extends StatefulWidget {
  final bool ishomepage;
  const MusicDetails({super.key, required this.ishomepage});

  @override
  State<MusicDetails> createState() => _MusicDetailsState();
}

class _MusicDetailsState extends State<MusicDetails>
    with WidgetsBindingObserver {
  final MusicManager _musicManager = MusicManager();
  @override
  void initState() {
    super.initState();

    ambiguate(WidgetsBinding.instance)?.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: black));
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      debugPrint(
          "didChangeAppLifecycleState state ====================> $state.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Miniplayer(
      valueNotifier: playerExpandProgress,
      minHeight: playerMinHeight,
      duration: const Duration(seconds: 1),
      maxHeight: MediaQuery.of(context).size.height,
      controller: controller,
      elevation: 4,
      backgroundColor: colorPrimaryDark,
      onDismissed: () async {
        debugPrint("onDismissed");
        currentlyPlaying.value = null;
        await audioPlayer.stop();
      },
      curve: Curves.easeInOutCubicEmphasized,
      builder: (height, percentage) {
        final bool miniplayer = percentage < miniplayerPercentageDeclaration;
        if (!miniplayer) {
          return Scaffold(
            backgroundColor: white,
            body: Container(
              color: white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildAppBar(),
                    buildMusicPage(),
                  ],
                ),
              ),
            ),
          );
        }

        //Miniplayer in BuildMethod
        final percentageMiniplayer = percentageFromValueInRange(
            min: playerMinHeight,
            max: MediaQuery.of(context).size.height,
            value: height);

        final elementOpacity = 1 - 1 * percentageMiniplayer;
        final progressIndicatorHeight = 2 - 2 * percentageMiniplayer;
        // MiniPlayer End

        // Scaffold
        return Scaffold(
          body:
              buildMusicPanel(height, elementOpacity, progressIndicatorHeight),
        );
      },
    );
  }

// MiniPlayer AppBar
  Widget buildAppBar() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.38,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorPrimary,
                    colorPrimaryDark,
                  ],
                  end: Alignment.bottomLeft,
                  begin: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: transparent,
                    elevation: 0,
                    titleSpacing: 0,
                    automaticallyImplyLeading: false,
                    leading:
                        MyImage(width: 15, height: 15, imagePath: "back.png"),
                    title: const MyText(
                        color: white,
                        text: "Now Playing",
                        textalign: TextAlign.center,
                        fontsize: 20,
                        inter: 1,
                        maxline: 2,
                        fontwaight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                    centerTitle: true,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            )
          ],
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: StreamBuilder<SequenceState?>(
                stream: audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: MyNetworkImage(
                            imgWidth: MediaQuery.of(context).size.width * 0.70,
                            imgHeight:
                                MediaQuery.of(context).size.height * 0.35,
                            imageUrl: ((audioPlayer.sequenceState?.currentSource
                                        ?.tag as MediaItem?)
                                    ?.artUri)
                                .toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Positioned.fill(
                      //   right: 40,
                      //   child: Align(
                      //     alignment: Alignment.bottomRight,
                      //     child: InkWell(
                      //       onTap: () async {
                      //         final addfavouriteprovider =
                      //             Provider.of<AddFavouriteProvider>(context,
                      //                 listen: false);
                      //         Utils().showProgress(context);
                      //         await addfavouriteprovider.getAddFavourite(
                      //             "1", "3");

                      //         if (!addfavouriteprovider.loading) {
                      //           if (addfavouriteprovider
                      //                   .addfavouriteModel.status ==
                      //               200) {
                      //             if (!mounted) return;
                      //             Utils().hideProgress(context);
                      //             Utils.showSnackbar(
                      //                 context,
                      //                 addfavouriteprovider
                      //                     .addfavouriteModel.message
                      //                     .toString(),
                      //                 false);
                      //           } else {
                      //             if (!mounted) return;
                      //             Utils().hideProgress(context);
                      //             Utils.showSnackbar(
                      //                 context,
                      //                 addfavouriteprovider
                      //                     .addfavouriteModel.message
                      //                     .toString(),
                      //                 false);
                      //           }
                      //         }
                      //       },
                      //       child: Container(
                      //         width: 30,
                      //         height: 30,
                      //         alignment: Alignment.center,
                      //         decoration: const BoxDecoration(boxShadow: [
                      //           BoxShadow(
                      //             color: gray,
                      //             blurRadius: 20.0,
                      //           ),
                      //         ], color: white, shape: BoxShape.circle),
                      //         child: MyImage(
                      //             width: 20,
                      //             height: 20,
                      //             color: red,
                      //             imagePath: "ic_heart.png"),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }

// FullPage MiniPlayer Screen Open Using This Method
  Widget buildMusicPage() {
    return Column(
      children: [
        StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              return Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    StreamBuilder<SequenceState?>(
                        stream: audioPlayer.sequenceStateStream,
                        builder: (context, snapshot) {
                          return TextScroll(
                            intervalSpaces: 10,
                            mode: TextScrollMode.endless,
                            ((audioPlayer.sequenceState?.currentSource?.tag
                                        as MediaItem?)
                                    ?.album)
                                .toString(),
                            selectable: true,
                            delayBefore: const Duration(milliseconds: 500),
                            fadedBorder: true,
                            style: Utils.googleFontStyle(1, 20,
                                FontStyle.normal, black, FontWeight.w600),
                            fadeBorderVisibility: FadeBorderVisibility.auto,
                            fadeBorderSide: FadeBorderSide.both,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(50, 0)),
                          );
                          //   MyText(
                          //     fontsize: 20,
                          //     fontstyle: FontStyle.normal,
                          //     fontwaight: FontWeight.w600,
                          //     inter: 1,
                          //     maxline: 1,
                          //     overflow: TextOverflow.ellipsis,
                          //     textalign: TextAlign.center,
                          //     color: black,
                          //     text: ((audioPlayer.sequenceState?.currentSource
                          //                 ?.tag as MediaItem?)
                          //             ?.album)
                          //         .toString(),
                          //   );
                        }),
                    const SizedBox(height: 10),
                    StreamBuilder<SequenceState?>(
                        stream: audioPlayer.sequenceStateStream,
                        builder: (context, snapshot) {
                          return MyText(
                            fontsize: 12,
                            fontstyle: FontStyle.normal,
                            fontwaight: FontWeight.w500,
                            inter: 1,
                            maxline: 5,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.center,
                            color: gray,
                            text: ((audioPlayer.sequenceState?.currentSource
                                        ?.tag as MediaItem?)
                                    ?.title)
                                .toString(),
                          );
                        }),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                      child: StreamBuilder<PositionData>(
                        stream: positionDataStream,
                        builder: (context, snapshot) {
                          final positionData = snapshot.data;
                          return ProgressBar(
                            progress: positionData?.position ?? Duration.zero,
                            buffered:
                                positionData?.bufferedPosition ?? Duration.zero,
                            total: positionData?.duration ?? Duration.zero,
                            progressBarColor: red,
                            baseBarColor: lightgray,
                            bufferedBarColor: gray,
                            thumbColor: red,
                            barHeight: 4.0,
                            thumbRadius: 6.0,
                            timeLabelPadding: 5.0,
                            timeLabelType: TimeLabelType.totalTime,
                            timeLabelTextStyle: GoogleFonts.inter(
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              color: gray,
                              fontWeight: FontWeight.w700,
                            ),
                            onSeek: (duration) {
                              audioPlayer.seek(duration);
                            },
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StreamBuilder<SequenceState?>(
                          stream: audioPlayer.sequenceStateStream,
                          builder: (context, snapshot) => InkWell(
                            onTap: audioPlayer.hasPrevious
                                ? audioPlayer.seekToPrevious
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: MyImage(
                                  width: 25,
                                  height: 25,
                                  imagePath: "ic_previous.png"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        // 10 Second Privious
                        StreamBuilder<PositionData>(
                          stream: positionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;
                            return InkWell(
                                onTap: () {
                                  tenSecNextOrPrevious(
                                      positionData?.position.inSeconds
                                              .toString() ??
                                          "",
                                      false);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: MyImage(
                                      width: 30,
                                      height: 30,
                                      imagePath: "ic_backward.png"),
                                ));
                          },
                        ),
                        const SizedBox(width: 15),
                        // Pause and Play Controll
                        StreamBuilder<PlayerState>(
                          stream: audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final processingState =
                                playerState?.processingState;
                            final playing = playerState?.playing;
                            if (processingState == ProcessingState.loading ||
                                processingState == ProcessingState.buffering) {
                              return Container(
                                margin: const EdgeInsets.all(8.0),
                                width: 50.0,
                                height: 50.0,
                                child: const CircularProgressIndicator(
                                  color: colorAccent,
                                ),
                              );
                            } else if (playing != true) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      colorPrimary,
                                      colorPrimaryDark,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: white,
                                  ),
                                  color: white,
                                  iconSize: 50.0,
                                  onPressed: audioPlayer.play,
                                ),
                              );
                            } else if (processingState !=
                                ProcessingState.completed) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      colorPrimary,
                                      colorPrimaryDark,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.pause_rounded,
                                    color: white,
                                  ),
                                  iconSize: 50.0,
                                  color: white,
                                  onPressed: audioPlayer.pause,
                                ),
                              );
                            } else {
                              return IconButton(
                                icon: const Icon(
                                  Icons.replay_rounded,
                                  color: white,
                                ),
                                iconSize: 60.0,
                                onPressed: () => audioPlayer.seek(Duration.zero,
                                    index: audioPlayer.effectiveIndices!.first),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 15),
                        // 10 Second Next
                        StreamBuilder<PositionData>(
                          stream: positionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;

                            return InkWell(
                                onTap: () {
                                  tenSecNextOrPrevious(
                                      positionData?.position.inSeconds
                                              .toString() ??
                                          "",
                                      true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: MyImage(
                                      width: 30,
                                      height: 30,
                                      imagePath: "ic_forward.png"),
                                ));
                          },
                        ),
                        const SizedBox(width: 15),
                        // Next Audio Play
                        StreamBuilder<SequenceState?>(
                          stream: audioPlayer.sequenceStateStream,
                          builder: (context, snapshot) => InkWell(
                            onTap: audioPlayer.hasNext
                                ? audioPlayer.seekToNext
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: MyImage(
                                  width: 25,
                                  height: 25,
                                  imagePath: "ic_next.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Volumn Costome Set
                          IconButton(
                            iconSize: 30.0,
                            icon: const Icon(Icons.volume_up),
                            color: black,
                            onPressed: () {
                              showSliderDialog(
                                context: context,
                                title: "Adjust volume",
                                divisions: 10,
                                min: 0.0,
                                max: 2.0,
                                value: audioPlayer.volume,
                                stream: audioPlayer.volumeStream,
                                onChanged: audioPlayer.setVolume,
                              );
                            },
                          ),
                          // Audio Speed Costomized
                          StreamBuilder<double>(
                            stream: audioPlayer.speedStream,
                            builder: (context, snapshot) => IconButton(
                              icon: Text(
                                overflow: TextOverflow.ellipsis,
                                "${snapshot.data?.toStringAsFixed(1)}x",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: black,
                                    fontSize: 14),
                              ),
                              onPressed: () {
                                showSliderDialog(
                                  context: context,
                                  title: "Adjust speed",
                                  divisions: 10,
                                  min: 0.5,
                                  max: 2.0,
                                  value: audioPlayer.speed,
                                  stream: audioPlayer.speedStream,
                                  onChanged: audioPlayer.setSpeed,
                                );
                              },
                            ),
                          ),
                          // Loop Node Button
                          StreamBuilder<LoopMode>(
                            stream: audioPlayer.loopModeStream,
                            builder: (context, snapshot) {
                              final loopMode = snapshot.data ?? LoopMode.off;
                              const icons = [
                                Icon(Icons.repeat, color: black, size: 30.0),
                                Icon(Icons.repeat, color: red, size: 30.0),
                                Icon(Icons.repeat_one, color: red, size: 30.0),
                              ];
                              const cycleModes = [
                                LoopMode.off,
                                LoopMode.all,
                                LoopMode.one,
                              ];
                              final index = cycleModes.indexOf(loopMode);
                              return IconButton(
                                icon: icons[index],
                                onPressed: () {
                                  audioPlayer.setLoopMode(cycleModes[
                                      (cycleModes.indexOf(loopMode) + 1) %
                                          cycleModes.length]);
                                },
                              );
                            },
                          ),
                          // Suffle Button
                          StreamBuilder<bool>(
                            stream: audioPlayer.shuffleModeEnabledStream,
                            builder: (context, snapshot) {
                              final shuffleModeEnabled = snapshot.data ?? false;
                              return IconButton(
                                iconSize: 30.0,
                                icon: shuffleModeEnabled
                                    ? const Icon(Icons.shuffle, color: red)
                                    : const Icon(Icons.shuffle, color: black),
                                onPressed: () async {
                                  final enable = !shuffleModeEnabled;
                                  if (enable) {
                                    await audioPlayer.shuffle();
                                  }
                                  await audioPlayer
                                      .setShuffleModeEnabled(enable);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }

// Small MiniPlayer Panal Open Using This Method
  Widget buildMusicPanel(
      dynamicPanelHeight, elementOpacity, progressIndicatorHeight) {
    return Container(
      color: white,
      child: Column(
        children: [
          Opacity(
            opacity: elementOpacity,
            child: StreamBuilder<PositionData>(
              stream: positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  progressBarColor: red,
                  baseBarColor: colorAccent,
                  bufferedBarColor: white.withOpacity(0.24),
                  barCapShape: BarCapShape.square,
                  barHeight: progressIndicatorHeight,
                  thumbRadius: 0.0,
                  timeLabelLocation: TimeLabelLocation.none,
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Opacity(
              opacity: elementOpacity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* Music Image */
                  StreamBuilder<SequenceState?>(
                    stream: audioPlayer.sequenceStateStream,
                    builder: (context, snapshot) {
                      return Container(
                        width: 90,
                        height: 60,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: MyNetworkImage(
                            imgWidth: MediaQuery.of(context).size.width,
                            imgHeight: MediaQuery.of(context).size.height,
                            imageUrl: ((audioPlayer.sequenceState?.currentSource
                                        ?.tag as MediaItem?)
                                    ?.artUri)
                                .toString(),
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: StreamBuilder<SequenceState?>(
                        stream: audioPlayer.sequenceStateStream,
                        builder: (context, snapshot) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextScroll(
                                intervalSpaces: 10,
                                mode: TextScrollMode.endless,
                                ((audioPlayer.sequenceState?.currentSource?.tag
                                            as MediaItem?)
                                        ?.album)
                                    .toString(),
                                selectable: true,
                                delayBefore: const Duration(milliseconds: 500),
                                fadedBorder: true,
                                style: Utils.googleFontStyle(1, 16,
                                    FontStyle.normal, black, FontWeight.w500),
                                fadeBorderVisibility: FadeBorderVisibility.auto,
                                fadeBorderSide: FadeBorderSide.both,
                                velocity: const Velocity(
                                    pixelsPerSecond: Offset(50, 0)),
                              ),
                              const SizedBox(height: 5),
                              MyText(
                                  color: black,
                                  text: ((audioPlayer
                                              .sequenceState
                                              ?.currentSource
                                              ?.tag as MediaItem?)
                                          ?.title)
                                      .toString(),
                                  textalign: TextAlign.left,
                                  fontsize: 12,
                                  inter: 1,
                                  maxline: 1,
                                  fontwaight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal),
                              const SizedBox(height: 5),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder<SequenceState?>(
                        stream: audioPlayer.sequenceStateStream,
                        builder: (context, snapshot) {
                          if (dynamicPanelHeight <= playerMinHeight) {
                            if (audioPlayer.hasPrevious) {
                              return IconButton(
                                iconSize: 25.0,
                                icon: const Icon(
                                  Icons.skip_previous_rounded,
                                  color: black,
                                ),
                                onPressed: audioPlayer.hasPrevious
                                    ? audioPlayer.seekToPrevious
                                    : null,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      /* Play/Pause */
                      StreamBuilder<PlayerState>(
                        stream: audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          if (dynamicPanelHeight <= playerMinHeight) {
                            final playerState = snapshot.data;
                            final processingState =
                                playerState?.processingState;
                            final playing = playerState?.playing;
                            if (processingState == ProcessingState.loading ||
                                processingState == ProcessingState.buffering) {
                              return Container(
                                margin: const EdgeInsets.all(8.0),
                                width: 35.0,
                                height: 35.0,
                                child: Utils.pageLoader(),
                              );
                            } else if (playing != true) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: colorAccent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: white,
                                  ),
                                  color: white,
                                  iconSize: 20.0,
                                  onPressed: audioPlayer.play,
                                ),
                              );
                            } else if (processingState !=
                                ProcessingState.completed) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: colorAccent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.pause_rounded,
                                    color: white,
                                  ),
                                  iconSize: 20.0,
                                  color: white,
                                  onPressed: audioPlayer.pause,
                                ),
                              );
                            } else {
                              return IconButton(
                                icon: const Icon(
                                  Icons.replay_rounded,
                                  color: white,
                                ),
                                iconSize: 25.0,
                                onPressed: () => audioPlayer.seek(Duration.zero,
                                    index: audioPlayer.effectiveIndices!.first),
                              );
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      /* Next */
                      StreamBuilder<SequenceState?>(
                        stream: audioPlayer.sequenceStateStream,
                        builder: (context, snapshot) {
                          if (dynamicPanelHeight <= playerMinHeight) {
                            if (audioPlayer.hasNext) {
                              return IconButton(
                                iconSize: 25.0,
                                icon: const Icon(
                                  Icons.skip_next_rounded,
                                  color: black,
                                ),
                                onPressed: audioPlayer.hasNext
                                    ? audioPlayer.seekToNext
                                    : null,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 10 Second Next And Previous Functionality
  // bool isnext = true > next Audio Seek
  // bool isnext = false > previous Audio Seek
  tenSecNextOrPrevious(String audioposition, bool isnext) {
    dynamic firstHalf = Duration(seconds: int.parse(audioposition));
    const secondHalf = Duration(seconds: 10);
    Duration movePosition;
    if (isnext == true) {
      movePosition = firstHalf + secondHalf;
    } else {
      movePosition = firstHalf - secondHalf;
    }

    _musicManager.seek(movePosition);
  }
}

// Audio Data Contructer
class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({
    required this.album,
    required this.title,
    required this.artwork,
  });
}
