enum IntervalType {
  work,
  recovery,
  warmup,
  cooldown,
  breath;

  static IntervalType fromString(String value) {
    return IntervalType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => IntervalType.work,
    );
  }
}
