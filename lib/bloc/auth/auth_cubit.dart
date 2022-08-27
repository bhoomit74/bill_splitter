import 'package:bill_splitter/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  var authRepository = AuthRepository();
  var firebaseAuth = FirebaseAuth.instance;
  var userRef = FirebaseDatabase.instance.ref("user");
  var username = "";
  AuthCubit() : super(AuthInitial());

  createAccount(username,email,password){
    emit(AuthLoading());
    firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async{
      await updateUserInfo(username);
      await _createUser();
      emit(AuthSuccess());
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
            if (kDebugMode) {
              print("User created successfully");
            }
          })
          .onError((error, stackTrace){
            emit(AuthError(error.toString()));
          });
    }
  }

  Future<dynamic> getUserDetail()async{
    emit(AuthLoading());
    userRef.child(firebaseAuth.currentUser?.uid??"").get()
        .then((value){
          username = value.child("name").value.toString();
      print("getUserDetail: ${value.child("name").value}");
      emit(AuthSuccess());
    }).onError((error, stackTrace){
      emit(AuthError(error.toString()));
    });
  }

  Future<dynamic> updateUserInfo(String name)async{
    firebaseAuth.currentUser?.updateDisplayName(name)
        .then((value){
        })
        .onError((error, stackTrace){
          print(error.toString());
        });
  }
}
