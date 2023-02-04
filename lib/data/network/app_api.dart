import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:temp/app/constants.dart';
import 'package:temp/data/response/responses.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST("/customer/login")
  Future<AuthenticationResponse> login(
    @Field("email") String email,
    @Field("password") String password,
  );

  // forgetPassword
  @POST("/customer/forgetPassword")
  Future<ForgetPasswordSupportMessageResponse> forgetPassword(
    @Field("email") String email,
  );

  @POST("/customer/register")
  Future<AuthenticationResponse> register(
    @Field("user_name") String userName,
    @Field("country_mobile_code") String countryMobileCode,
    @Field("mobile_number") String mobileNumber,
    @Field("email") String email,
    @Field("password") String password,
    @Field("profile_picture") String profilePicture,
  );
}
