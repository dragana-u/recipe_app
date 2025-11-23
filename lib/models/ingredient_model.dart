class Ingredient {
  String name;
  String measure;

  Ingredient({required this.name, required this.measure});

  Map<String, dynamic> toJson() => {'name': name, 'measure': measure};
}
