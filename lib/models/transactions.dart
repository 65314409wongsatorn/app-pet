class Transactions {
  final String? keyID;  
  final String title;    
  final String owner;    
  final String breed;    
  final double amount;   
  final DateTime date;   
  final String? imagePath; 

  Transactions({
    required this.keyID,
    required this.title,
    required this.owner,
    required this.breed,
    required this.amount,
    required this.date,
    this.imagePath,
  });
}
