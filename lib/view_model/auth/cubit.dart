import 'package:fcis_guide/model/remote/firebase_service/errors.dart';
import 'package:fcis_guide/model/remote/firebase_service/auth_service/auth_services.dart';
import 'package:fcis_guide/modules/base_widgets/toast.dart';
import 'package:fcis_guide/view_model/auth/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';

class AuthCubit extends Cubit<AuthStates>
{
  AuthCubit() : super(AuthInitial());

  factory AuthCubit.getInstance(context) => BlocProvider.of(context);

  Future<void> auth(context,{
    required FirebaseAuthService authService,
    required String email,
    required String password,
})async
  {
    emit(AuthLoading());

    Result<UserCredential, FirebaseError> result = await authService.callFirebaseAuth(
      email: email,
      password: password,
    );

    if(result.isSuccess())
      {
        MyToast.showToast(context,msg: 'Welcome', color: Colors.green);
        emit(AuthSuccess());
      }
    else{
      emit(AuthError(result.tryGetError()?.message));
    }
  }

  Future<void> logout()async
  {
    await FirebaseAuth.instance.signOut();
    emit(AuthSuccess());
  }

}