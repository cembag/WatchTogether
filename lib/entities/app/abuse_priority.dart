enum AbusePriority {
  high,
  medium,
  low,
}

String abusePriorityToString(AbusePriority abusePriority) {
  switch(abusePriority) {
    case AbusePriority.high:
      return "high";
    case AbusePriority.medium:
      return "medium";
    case AbusePriority.low:
      return "low";
  }
}

AbusePriority abusePriorityFromString(String abusePriority) {
  switch(abusePriority) {
    case "high":
      return AbusePriority.high;
    case "medium":
      return AbusePriority.medium;
    case "low":
      return AbusePriority.low;
    default:
      return AbusePriority.low;
  }
}