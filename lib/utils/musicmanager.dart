import 'dart:developer';
import 'package:just_audio/just_audio.dart';
import 'package:radioapp/pages/home.dart';
import 'package:radioapp/pages/musicdetails.dart';
import 'package:radioapp/widget/musicutils.dart';

class MusicManager {
  late ConcatenatingAudioSource playlist;

  dynamic episodeDataList;

  MusicManager();

// Data change Using This Playlist (Api Data Set in This ArrayList And After Set data From This ArrayList)
  void setInitialPlaylist(int cPosition, dynamic dataList) async {
    currentlyPlaying.value = audioPlayer;
    playlist = ConcatenatingAudioSource(children: []);
    log("dataList :=====================> ${dataList.length}");
    episodeDataList = dataList.toList();
    for (int i = 0; i < (episodeDataList?.length ?? 0); i++) {
      playlist.add(
        buildAudioSource(
          audioUrl: episodeDataList?[i].songUrl.toString() ?? "",
          name: episodeDataList?[i].name.toString() ?? "",
          audioId: episodeDataList?[i].id.toString() ?? "",
          title: episodeDataList?[i].languageName.toString() ?? "",
          description: episodeDataList?[i].artistName.toString() ?? "",
          audioThumb: episodeDataList?[i].image.toString() ?? "",
        ),
      );
    }

    try {
      log("playing      :=====================> ${audioPlayer.playing}");
      log("audioSource  :=====================> ${audioPlayer.audioSource?.sequence.length}");
      log("playlist     :=====================> ${playlist.length}");
      // Preloading audio is not currently supported on Linux.
      await audioPlayer.setAudioSource(playlist, initialIndex: cPosition);
      play();
    } catch (e) {
      // Catch load errors: 404, invalid url...
      log("Error loading audio source: $e");
    }
  }

  void playSingleSong(
      String songId, String name, String songUrl, String songThumb) async {
    currentlyPlaying.value = audioPlayer;
    ConcatenatingAudioSource singlePlaylist =
        ConcatenatingAudioSource(children: []);
    singlePlaylist.add(buildAudioSource(
      audioUrl: songUrl.toString(),
      audioId: songId.toString(),
      title: name.toString(),
      description: name.toString(),
      name: name.toString(),
      audioThumb: songThumb.toString(),
    ));
    try {
      log("playing        :=====================> ${audioPlayer.playing}");
      log("singlePlaylist :=====================> ${singlePlaylist.length}");
      // Preloading audio is not currently supported on Linux.
      await audioPlayer.setAudioSource(singlePlaylist);
      play();
    } catch (e) {
      // Catch load errors: 404, invalid url...
      log("Error loading audio source: $e");
    }
  }

// Play Audio Using This Method
  void play() async {
    audioPlayer.play();
  }

// Stop Audio Using This Method
  void pause() {
    audioPlayer.pause();
  }

// Forward and Backward Method
  void seek(Duration position) {
    audioPlayer.seek(position);
  }

//  Audio Player Dispose Using This Method
  void dispose() {
    audioPlayer.dispose();
  }
}
