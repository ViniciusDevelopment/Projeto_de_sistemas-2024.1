import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class Authentication {
  //Criar instância do autenticador do firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Criar get currentUser para pegar o usuario atual
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Criar função com metodo signInWithEmailAndPassword do firebase para login
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  //Criar função com metodo createUserWithEmailAndPassword do firebase para cadastro
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  //Criar função com metodo createUserWithEmailAndPassword do firebase para sair
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
