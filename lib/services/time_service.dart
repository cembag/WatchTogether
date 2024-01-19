class TimeService {

  static String secondsToMMss(int seconds) {
    final minutes = seconds~/60;
    final secs = seconds%60;
    return minutes > 0 ? "${(minutes).toString().padLeft(2, '0')}:${(secs).toString().padLeft(2, '0')}" : secs.toString().padLeft(2, '0');
  }
}