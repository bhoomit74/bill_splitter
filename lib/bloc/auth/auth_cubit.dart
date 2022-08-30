import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  var firebaseAuth = FirebaseAuth.instance;
  var userRef = FirebaseDatabase.instance.ref("user");
  var username = "";
  AuthCubit() : super(AuthInitial());

  createAccount(username,email,password){
    emit(AuthLoading());
    firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)
        .then((value){
      updateUserInfo(username);
    }).onError((error, stackTrace){
      emit(AuthError(error.toString()));
    });
  }

  login(email, password){
    emit(AuthLoading());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value){
      emit(AuthSuccess());
    }).onError((error, stackTrace){
      emit(AuthError(error.toString()));
    });
  }

  _createUser(){
    if(firebaseAuth.currentUser!=null){
      var user = {
        "id" : firebaseAuth.currentUser?.uid,
        "name" : firebaseAuth.currentUser?.displayName,
        "email" : firebaseAuth.currentUser?.email
      };
      FirebaseDatabase.instance.ref("user")
          .child(firebaseAuth.currentUser!.uid.toString())
          .set(user)
          .then((value){
            emit(AuthSuccess());
            if (kDebugMode) {
              print("User created successfully");
            }
          })
          .onError((error, stackTrace){
            emit(AuthError(error.toString()));
          });
    }
  }

  updateUserInfo(String name){
    firebaseAuth.currentUser?.updateDisplayName(name)
        .then((value){
          _createUser();
        })
        .onError((error, stackTrace){
          if (kDebugMode) {
            print(error.toString());
          }
        });
  }
}
