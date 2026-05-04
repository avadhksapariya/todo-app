import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource(this._auth, this._firestore);

  Stream<UserEntity?> get authStateChanges => _auth.authStateChanges().map(
    (user) =>
        user == null ? null : UserEntity(id: user.uid, email: user.email ?? ''),
  );

  Future<UserEntity> signIn(String email, String password) async {
    // Check if user is deleted
    final query = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty && query.docs.first.data()['isDeleted'] == true) {
      throw Exception('This account has been deleted.');
    }

    await _auth.signInWithEmailAndPassword(email: email, password: password);
    final current = _auth.currentUser!;

    return UserEntity(id: current.uid, email: current.email ?? '');
  }

  Future<UserEntity> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final current = _auth.currentUser!;
    final user = UserEntity(id: current.uid, email: current.email ?? '');
    // Save user record
    await _firestore.collection('users').doc(user.id).set({
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
      'isDeleted': false,
    });
    // Create default list
    await _firestore.collection('lists').add({
      'userId': user.id,
      'title': 'My Tasks',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return user;
  }

  Future<void> signOut() => _auth.signOut();

  /// Soft delete: mark user as deleted in Firestore, then delete Firebase auth account
  Future<void> deleteAccount() async {
    final uid = _auth.currentUser?.uid;

    if (uid != null) {
      // only mark deleted in Firestore
      await _firestore.collection('users').doc(uid).set({
        'isDeleted': true,
      }, SetOptions(merge: true));

      // await _auth.currentUser!.delete(); // No delete from Firebase auth

      await _auth.signOut();
    }
  }

  UserEntity? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return UserEntity(id: user.uid, email: user.email ?? '');
  }
}
