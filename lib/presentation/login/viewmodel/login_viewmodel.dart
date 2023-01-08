import 'dart:async';

import 'package:temp/domain/usecase/login_usecase.dart';
import 'package:temp/presentation/base/base_viewmodel.dart';
import 'package:temp/presentation/common/freezed_data_classes.dart';

class LoginViewModel extends BaseViewModel
    with _LoginViewModelInputs, _LoginViewModelOutputs {
  final StreamController<String> _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController<String> _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController<void> _areAllInputsValidStreamController =
      StreamController<void>.broadcast();

  LoginObject loginObject = LoginObject("", "");

  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);
  // inputs
  @override
  void start() {}
  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
  }

  @override
  Sink<String> get inputUserName => _userNameStreamController.sink;
  @override
  Sink<String> get inputPassword => _passwordStreamController.sink;
  @override
  Sink<void> get inputAreAllInputsValid =>
      _areAllInputsValidStreamController.sink;

  @override
  void setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    inputAreAllInputsValid.add(null);
  }

  @override
  void setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputAreAllInputsValid.add(null);
  }

  @override
  Future<void> login() async {
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold(
      (left) => {
        // left -> failure
        print(left.message)
      },
      (right) => {
        // right -> data  (success)
        print(right.customer?.name)
      },
    );
  }

  // outputs
  @override
  Stream<bool> get outIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));
  @override
  Stream<bool> get outIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));
  @override
  Stream<bool> get outAreAllInputsValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());

  bool _isUserNameValid(String userName) => userName.isNotEmpty;
  bool _isPasswordValid(String password) => password.isNotEmpty;
  bool _areAllInputsValid() =>
      _isUserNameValid(loginObject.userName) &&
      _isPasswordValid(loginObject.password);
}

abstract class _LoginViewModelInputs {
  void setUserName(String userName);
  void setPassword(String password);
  void login();

  Sink<String> get inputUserName;
  Sink<String> get inputPassword;
  Sink<void> get inputAreAllInputsValid;
}

abstract class _LoginViewModelOutputs {
  Stream<bool> get outIsUserNameValid;
  Stream<bool> get outIsPasswordValid;
  Stream<bool> get outAreAllInputsValid;
}
