class FirestoreResult<T> {
  bool success;
  String? message;
  T? payload;

  FirestoreResult(
    this.payload, {
    required this.success,
    this.message,
  });
}
