import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import '../../network/network.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  var firebaseAuth = FirebaseAuth.instance;
  var userRef = FirebaseDatabase.instance.ref("user");
  var username = "";
  AuthCubit() : super(AuthInitial());

  createAccount(username, email, password) async {
    emit(AuthLoading());
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await updateDisplayName(username);
      await addCurrentUser();
    } on FirebaseException catch (e) {
      emit(AuthError(e.message ?? ""));
    }
  }

  login(email, password) async {
    emit(AuthLoading());
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      emit(AuthSuccess());
    } on FirebaseException catch (e) {
      emit(AuthError(e.message ?? ""));
    }
  }

  addCurrentUser() async {
    var currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      var user = AppUser(
              id: currentUser.uid,
              name: currentUser.displayName,
              email: currentUser.email)
          .toJson();

      try {
        await Reference.users.child(currentUser.uid).set(user);
        emit(AuthSuccess());
      } on FirebaseException catch (e) {
        emit(AuthError(e.message ?? ""));
      }
    }
  }

  updateDisplayName(String name) async {
    try {
      await firebaseAuth.currentUser?.updateDisplayName(name);
    } on FirebaseException catch (e) {
      emit(AuthError(e.message ?? ""));
    }
  }
}
