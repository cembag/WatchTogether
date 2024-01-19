enum SentStatus {
  success,
  fail,
}

String sentStatusToString(SentStatus sentStatus) {
  switch(sentStatus) {
    case SentStatus.success:
      return "success";
    case SentStatus.fail:
      return "fail";
  }
}

SentStatus sentStatusFromString(String sentStatus) {
  switch(sentStatus) {
    case "success":
      return SentStatus.success;
    case "fail":
      return SentStatus.fail;
    default:
      return SentStatus.fail;
  }
}