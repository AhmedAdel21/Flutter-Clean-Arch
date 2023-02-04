import 'package:flutter/material.dart';
import 'package:temp/app/di.dart';
import 'package:temp/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:temp/presentation/forgot_password/viewmodel/forgot_password_viewmodel.dart';
import 'package:temp/presentation/resources/assets_manager.dart';
import 'package:temp/presentation/resources/color_manager.dart';
import 'package:temp/presentation/resources/strings_manager.dart';
import 'package:temp/presentation/resources/values_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final ForgetPasswordViewModel _forgetPasswordModel =
      instance<ForgetPasswordViewModel>();

  final _formKey = GlobalKey<FormState>();
  _bind() {
    _emailTextEditingController.addListener(() {
      _forgetPasswordModel.setEmail(_emailTextEditingController.text);
    });
  }

  @override
  void initState() {
    super.initState();
    _bind();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: AppBar(
        elevation: AppSizeConstants.s0,
        backgroundColor: ColorConstants.white,
        iconTheme: const IconThemeData(color: ColorConstants.primary),
      ),
      body: StreamBuilder<FlowState>(
        stream: _forgetPasswordModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  _forgetPasswordModel.forgetPassword) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPaddingConstants.p28),
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Center(
              child: Image(image: AssetImage(ImageAssets.splashLogo)),
            ),
            const SizedBox(
              height: AppSizeConstants.s28,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: AppPaddingConstants.p28,
                  right: AppPaddingConstants.p28),
              child: StreamBuilder<String?>(
                  stream: _forgetPasswordModel.outputErrorEmail,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextEditingController,
                      decoration: InputDecoration(
                          hintText: AppStrings.emailHint,
                          labelText: AppStrings.emailHint,
                          errorText: snapshot.data),
                    );
                  }),
            ),
            const SizedBox(
              height: AppSizeConstants.s40,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: AppPaddingConstants.p28,
                  right: AppPaddingConstants.p28),
              child: StreamBuilder<bool>(
                  stream: _forgetPasswordModel.outputAreAllInputsValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppSizeConstants.s40,
                      child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  _forgetPasswordModel.forgetPassword();
                                }
                              : null,
                          child: const Text(AppStrings.resetPassword)),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: AppPaddingConstants.p18,
                  left: AppPaddingConstants.p28,
                  right: AppPaddingConstants.p28),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppStrings.didNotReceiveEmail,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
