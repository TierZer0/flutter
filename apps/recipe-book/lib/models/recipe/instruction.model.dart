class InstructionModel {
  String? title;
  int? order;
  String? description;

  InstructionModel({
    this.title,
    this.order,
    this.description,
  });

  List<InstructionModel> fromMap(List<dynamic> instructions) {
    return instructions
        .map(
          (instruction) => InstructionModel(
            title: instruction['title'],
            order: instruction['order'],
            description: instruction['description'],
          ),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (order != null) 'order': order,
      if (description != null) 'description': description
    };
  }

  @override
  String toString() {
    return 'Step $order: $title - $description';
  }
}
