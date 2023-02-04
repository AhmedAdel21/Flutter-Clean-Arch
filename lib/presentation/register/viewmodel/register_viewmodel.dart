import 'dart:async';
import 'dart:io';

import 'package:temp/app/app_prefs.dart';
import 'package:temp/app/di.dart';
import 'package:temp/app/functions.dart';
import 'package:temp/domain/usecase/register_usecase.dart';
import 'package:temp/presentation/base/base_viewmodel.dart';
import 'package:temp/presentation/common/freezed_data_classes.dart';
import 'package:temp/presentation/common/state_renderer/state_renderer.dart';
import 'package:temp/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:temp/presentation/resources/strings_manager.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInput, RegisterViewModelOutput {
  StreamController<String> userNameStreamController =
      StreamController<String>.broadcast();
  StreamController<String> mobileStreamController =
      StreamController<String>.broadcast();
  StreamController<String> emailStreamController =
      StreamController<String>.broadcast();
  StreamController<String> passwordStreamController =
      StreamController<String>.broadcast();
  StreamController<File> profilePictureStreamController =
      StreamController<File>.broadcast();
  StreamController<void> areAllInputsValidStreamController =
      StreamController<void>.broadcast();

  final StreamController<bool> isUserRegisteredInSuccessfullyStreamController =
      StreamController<bool>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  RegisterObject registerObject = RegisterObject("", "", "", "", "", "");
  final RegisterUseCase _registerUseCase;

  RegisterViewModel(this._registerUseCase);
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    userNameStreamController.close();
    mobileStreamController.close();
    emailStreamController.close();
    passwordStreamController.close();
    profilePictureStreamController.close();
    areAllInputsValidStreamController.close();
    isUserRegisteredInSuccessfullyStreamController.close();
    super.dispose();
  }

  // -- Inputs

  @override
  Sink<String> get inputEmail => emailStreamController.sink;
  @override
  Sink<String> get inputMobileNumber => mobileStreamController.sink;
  @override
  Sink<String> get inputPassword => passwordStreamController.sink;
  @override
  Sink<File> get inputProfilePicture => profilePictureStreamController.sink;
  @override
  Sink<String> get inputUserName => userNameStreamController.sink;
  @override
  Sink<void> get inputAreAllInputsValid =>
      areAllInputsValidStreamController.sink;

  // -- Outputs

  @override
  Stream<bool> get outputIsUserNameValid => userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));
  @override
  Stream<String?> get outputErrorUserName => outputIsUserNameValid
      .map((isUsername) => isUsername ? null : AppStrings.userNameInvalid);

  @override
  Stream<bool> get outputIsEmailValid =>
      emailStreamController.stream.map((email) => isEmailValid(email));
  @override
  Stream<String?> get outputErrorEmail => outputIsEmailValid
      .map((isEmailValid) => isEmailValid ? null : AppStrings.invalidEmail);

  @override
  Stream<bool> get outputIsMobileNumberValid => mobileStreamController.stream
      .map((mobileNumber) => _isMobileNumberValid(mobileNumber));
  @override
  Stream<String?> get outputErrorMobileNumber =>
      outputIsMobileNumberValid.map((isMobileNumberValid) =>
          isMobileNumberValid ? null : AppStrings.mobileNumberInvalid);

  @override
  Stream<bool> get outputIsPasswordValid => passwordStreamController.stream
      .map((password) => _isPasswordValid(password));
  @override
  Stream<String?> get outputErrorPassword => outputIsPasswordValid.map(
      (isPasswordValid) => isPasswordValid ? null : AppStrings.passwordInvalid);

  @override
  Stream<File> get outputProfilePicture =>
      profilePictureStreamController.stream.map((file) => file);

  @override
  Stream<bool> get outputAreAllInputsValid =>
      areAllInputsValidStreamController.stream.map((_) => _areAllInputsValid());

  @override
  void register() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _registerUseCase.execute(
      RegisterUseCaseInput(
        registerObject.userName,
        registerObject.countryMobileCode,
        registerObject.mobileNumber,
        registerObject.email,
        registerObject.password,
        // registerObject.profilePicture
        "",
      ),
    ))
        .fold(
      (left) {
        // left -> failure
        inputState.add(ErrorState(
            stateRendererType: StateRendererType.popupErrorState,
            message: left.message));
      },
      (right) {
        // right -> data  (success)
        inputState.add(ContentState());
        // navigate to home screen
        _appPreferences.setUserLoggedIn();
        isUserRegisteredInSuccessfullyStreamController.add(true);
      },
    );
  }

  @override
  void setUserName(String userName) {
    inputUserName.add(userName);
    if (_isUserNameValid(userName)) {
      // update register view object
      registerObject = registerObject.copyWith(userName: userName);
    } else {
      // reset userName value in register view object
      registerObject = registerObject.copyWith(userName: "");
    }
    validate();
  }

  @override
  void setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      // update register view object
      registerObject = registerObject.copyWith(password: password);
    } else {
      // reset password value in register view object
      registerObject = registerObject.copyWith(password: "");
    }
    validate();
  }

  @override
  void setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      // update register view object
      registerObject = registerObject.copyWith(email: email);
    } else {
      // reset email value in register view object
      registerObject = registerObject.copyWith(email: "");
    }
    validate();
  }

  @override
  void setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    if (_isMobileNumberValid(mobileNumber)) {
      // update register view object
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      // reset mobileNumber value in register view object
      registerObject = registerObject.copyWith(mobileNumber: "");
    }
    validate();
  }

  @override
  void setProfilePicture(File profilePicture) {
    inputProfilePicture.add(profilePicture);
    if (profilePicture.path.isNotEmpty) {
      // update register view object
      registerObject =
          registerObject.copyWith(profilePicture: profilePicture.path);
    } else {
      // reset profilePicture value in register view object
      registerObject = registerObject.copyWith(profilePicture: "");
    }
    validate();
  }

  @override
  void setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      // update register view object
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      registerObject = registerObject.copyWith(countryMobileCode: "");
    }
    validate();
  }

  // -- Private Functions

  bool _isUserNameValid(String userName) => userName.length >= 8;
  bool _isMobileNumberValid(String mobileNumber) => mobileNumber.length >= 10;
  bool _isPasswordValid(String password) => password.length >= 6;
  bool _areAllInputsValid() {
    return registerObject.userName.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.email.isNotEmpty &&
        registerObject.mobileNumber.isNotEmpty &&
        registerObject.countryMobileCode.isNotEmpty &&
        registerObject.profilePicture.isNotEmpty;
  }

  void validate() => inputAreAllInputsValid.add(null);
}

abstract class RegisterViewModelInput {
  Sink<String> get inputUserName;
  Sink<String> get inputPassword;
  Sink<String> get inputMobileNumber;
  Sink<String> get inputEmail;
  Sink<File> get inputProfilePicture;
  Sink<void> get inputAreAllInputsValid;

  void setUserName(String userName);
  void setPassword(String password);
  void setMobileNumber(String mobileNumber);
  void setEmail(String email);
  void setProfilePicture(File profilePicture);
  void setCountryCode(String countryCode);
  void register();
}

abstract class RegisterViewModelOutput {
  Stream<bool> get outputIsUserNameValid;
  Stream<String?> get outputErrorUserName;

  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPassword;

  Stream<bool> get outputIsMobileNumberValid;
  Stream<String?> get outputErrorMobileNumber;

  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputErrorEmail;

  Stream<File> get outputProfilePicture;

  Stream<bool> get outputAreAllInputsValid;
}
