import 'package:flutter/material.dart';
import 'package:temp/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:temp/presentation/resources/assets_manager.dart';
import 'package:temp/presentation/resources/color_manager.dart';
import 'package:temp/presentation/resources/routes_manager.dart';
import 'package:temp/presentation/resources/strings_manager.dart';
import 'package:temp/presentation/resources/values_manager.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _loginViewModel = LoginViewModel();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _bind() {
    _loginViewModel.start();
    _userNameController.addListener(
        () => _loginViewModel.setUserName(_userNameController.text));
    _passwordController.addListener(
        () => _loginViewModel.setPassword(_passwordController.text));
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getContentWidget();
  }

  Widget _getContentWidget() {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: Container(
        padding: const EdgeInsets.only(top: AppPaddingConstants.p100),
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(children: [
                const Center(
                    child: Image(image: AssetImage(ImageAssets.splashLogo))),
                const SizedBox(
                  height: AppSizeConstants.s28,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddingConstants.p28),
                  child: StreamBuilder<bool>(
                      stream: _loginViewModel.outIsUserNameValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          controller: _userNameController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: AppStrings.username,
                            labelText: AppStrings.username,
                            errorText: (snapshot.data ?? true)
                                ? null
                                : AppStrings.usernameError,
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSizeConstants.s28,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddingConstants.p28),
                  child: StreamBuilder<bool>(
                      stream: _loginViewModel.outIsPasswordValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: AppStrings.password,
                            labelText: AppStrings.password,
                            errorText: (snapshot.data ?? true)
                                ? null
                                : AppStrings.passwordError,
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSizeConstants.s28,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddingConstants.p28),
                  child: StreamBuilder<bool>(
                      stream: _loginViewModel.outAreAllInputsValid,
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: double.infinity,
                          height: AppSizeConstants.s40,
                          child: ElevatedButton(
                              onPressed: (snapshot.data ?? false)
                                  ? () {
                                      _loginViewModel.login();
                                    }
                                  : null,
                              child: const Text(AppStrings.login)),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddingConstants.p12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text(
                          AppStrings.forgetPassword,
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onPressed: () {
                            Navigator.pushReplacementNamed(context, Routes.forgotPasswordRoute);
                        },
                      ),
                      TextButton(
                        child: Text(
                          AppStrings.registerText,
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onPressed: () {
                            Navigator.pushReplacementNamed(context, Routes.registerRoute);
                        },
                      ),
                    ],
                  ),
                ),
              ])),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginViewModel.dispose();
    super.dispose();
  }
}
