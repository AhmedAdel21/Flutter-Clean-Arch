class LoginRequest {
  String email;
  String password;
  LoginRequest(this.email, this.password);
}

class ForgetPasswordRequest {
  String email;

  ForgetPasswordRequest(this.email);
}

class RegisterRequest {
  String userName;
  String countryMobileCode;
  String mobileNumber;
  String email;
  String password;
  String profilePicture;
  RegisterRequest(
    this.userName,
    this.countryMobileCode,
    this.mobileNumber,
    this.email,
    this.password,
    this.profilePicture,
  );
}
