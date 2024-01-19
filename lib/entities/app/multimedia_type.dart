enum MultimediaType {
  image,
  voice,
  video
}

String multimediaToString(MultimediaType type) {
  switch(type) {
    case MultimediaType.image:
      return "image";
    case MultimediaType.voice:
      return "voice";
    case MultimediaType.video:
      return "video";
  }
}

MultimediaType multimediaFromString(String type) {
  switch(type) {
    case "image":
      return MultimediaType.image;
    case "voice":
      return MultimediaType.voice;
    case "video":
      return MultimediaType.video;
    default:
      return MultimediaType.image;
  }
}