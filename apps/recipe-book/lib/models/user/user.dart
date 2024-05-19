import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const User._();

  const factory User(String name, {DateTime? lastSeen, bool? darkTheme, List<String>? likes, List<String>? categories}) = _User;

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return User(
      data["name"],
      lastSeen: data["lastSeen"],
      darkTheme: data["darkTheme"],
      likes: data["likes"],
      categories: data["categories"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "lastSeen": lastSeen,
      "darkTheme": darkTheme,
      "likes": likes,
      "categories": categories,
    };
  }
}
