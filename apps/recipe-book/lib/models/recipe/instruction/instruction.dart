import 'package:freezed_annotation/freezed_annotation.dart';

part 'instruction.freezed.dart';

@freezed
class Instruction with _$Instruction {
  const Instruction._();

  const factory Instruction({
    String? title,
    String? description,
    int? order,
  }) = _Instruction;

  List<Instruction> fromMap(List<dynamic> instructions) {
    return instructions
        .map(
          (instruction) => Instruction(
            title: instruction['title'],
            order: instruction['order'],
            description: instruction['description'],
          ),
        )
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      if (title != null) 'title': title,
      if (order != null) 'order': order,
      if (description != null) 'description': description,
    };
  }
}
