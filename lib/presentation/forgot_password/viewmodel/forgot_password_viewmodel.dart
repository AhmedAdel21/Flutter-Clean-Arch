import 'dart:async';

import 'package:temp/app/functions.dart';
import 'package:temp/domain/usecase/forget_password_usecase.dart';
import 'package:temp/presentation/base/base_viewmodel.dart';
import 'package:temp/presentation/common/freezed_data_classes.dart';
import 'package:temp/presentation/common/state_renderer/state_renderer.dart';
import 'package:temp/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:temp/presentation/resources/strings_manager.dart';

class ForgetPasswordViewModel extends BaseViewModel
    with ForgetPasswordViewModelInput, ForgetPasswordViewModelOutputs {
  StreamController<String> emailStreamController =
      StreamController<String>.broadcast();
  StreamController<void> isEmailValidStreamController =
      StreamController<void>();

  ForgetPasswordObject _forgetPasswordObject = ForgetPasswordObject("");
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  ForgetPasswordViewModel(this._forgetPasswordUseCase);
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    emailStreamController.close();
    isEmailValidStreamController.close();
    super.dispose();
  }

  @override
  Sink<void> get inputAreAllInputsValid => throw UnimplementedError();

  @override
  Sink<String> get inputEmail => emailStreamController.sink;

  @override
  Stream<bool> get outputAreAllInputsValid =>
      emailStreamController.stream.map((_) => _areAllInputsValid());

  @override
  Stream<String?> get outputErrorEmail => outputIsEmailValid
      .map((isEmailValid) => isEmailValid ? null : AppStrings.invalidEmail);

  @override
  Stream<bool> get outputIsEmailValid =>
      emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  void setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      _forgetPasswordObject = _forgetPasswordObject.copyWith(email: email);
    } else {
      _forgetPasswordObject = _forgetPasswordObject.copyWith(email: "");
    }
  }

  bool _areAllInputsValid() {
    return isEmailValid(_forgetPasswordObject.email);
  }

  @override
  Future<void> forgetPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgetPasswordUseCase
            .execute(ForgetPasswordUseCaseInput(_forgetPasswordObject.email)))
        .fold((left) {
      // left -> failure
      inputState.add(ErrorState(
          stateRendererType: StateRendererType.popupErrorState,
          message: left.message));
    }, (right) {
      // right -> data  (success)

      inputState.add(SuccessState(right.supportMessage));
      // navigate to home screen
    });
  }
}

abstract class ForgetPasswordViewModelInput {
  Sink<String> get inputEmail;
  Sink<void> get inputAreAllInputsValid;
  void setEmail(String email);
  void forgetPassword();
}

abstract class ForgetPasswordViewModelOutputs {
  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputErrorEmail;

  Stream<bool> get outputAreAllInputsValid;
}
