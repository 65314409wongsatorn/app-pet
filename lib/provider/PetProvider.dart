import 'package:account/models/transactions.dart';
import 'package:flutter/material.dart';


class PetProvider with ChangeNotifier {
  List<Pet> _pets = [];

  List<Pet> get pets => _pets;

  void addPet(Pet pet) {
    _pets.add(pet);
    notifyListeners();
  }

  void deletePet(int? keyID) {
    _pets.removeWhere((pet) => pet.keyID == keyID);
    notifyListeners();
  }

  void updatePet(Pet updatedPet) {}
}
