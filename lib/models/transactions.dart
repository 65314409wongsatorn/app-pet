class Pet {
  final int? keyID;
  final String name;
  final String owner;
  final String breed;
  final int age;
  final String notes;
  final DateTime date; 
  final String? imagePath;

  Pet({
    this.keyID,
    required this.name,
    required this.owner,
    required this.breed,
    required this.age,
    required this.notes,
    required this.date, 
    this.imagePath,
  });
}
