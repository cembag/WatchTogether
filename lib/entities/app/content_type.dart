enum ContentType {
  image,
  text,
  video
}

String contentTypeToString(ContentType contentType) {
  switch(contentType) {
    case ContentType.image:
      return "image";
    case ContentType.text:
      return "text";
    case ContentType.video:
      return "video";
  }
}

ContentType stringToContentType(String contentType) {
  switch(contentType) {
    case "image":
      return ContentType.image;
    case "text":
      return ContentType.text;
    case "video":
      return ContentType.video;
    default:
      return ContentType.text;
  }
}