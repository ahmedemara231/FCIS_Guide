import 'package:fcis_guide/extensions/routes.dart';
import 'package:fcis_guide/model/remote/firebase_service/errors.dart';
import 'package:fcis_guide/model/remote/firebase_service/auth_service/auth_services.dart';
import 'package:fcis_guide/modules/base_widgets/toast.dart';
import 'package:fcis_guide/view/home/home.dart';
import 'package:fcis_guide/view_model/auth/handle_success/interface.dart';
import 'package:fcis_guide/view_model/auth/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';

class AuthCubit extends Cubit<AuthStates>
{
  AuthCubit() : super(AuthInitial());

  factory AuthCubit.getInstance(context) => BlocProvider.of(context);

  List<bool> invisiblePass = [true,true,true];
  void changePassVisibility(int index)
  {
    invisiblePass[index] = !invisiblePass[index];
    emit(ChangePassVisibility());
  }




  Future<void> auth(context,{
    required FirebaseAuthService authService,
    required HandleSuccess handleSuccess,
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
        handleSuccess.handleSuccess(context);
        MyToast.showToast(context,msg: 'Welcome', color: Colors.green);
        emit(AuthSuccess());
      }
    else{
      emit(AuthError(result.tryGetError()?.message));
    }
  }

  Future<void> handleLoginSuccess(BuildContext context)async{

  }

  Future<void> logout()async
  {
    await FirebaseAuth.instance.signOut();
    emit(AuthSuccess());
  }

}