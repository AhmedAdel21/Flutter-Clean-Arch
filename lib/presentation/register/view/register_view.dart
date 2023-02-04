import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temp/app/constants.dart';
import 'package:temp/app/di.dart';
import 'package:temp/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:temp/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:temp/presentation/resources/assets_manager.dart';
import 'package:temp/presentation/resources/color_manager.dart';
import 'package:temp/presentation/resources/routes_manager.dart';
import 'package:temp/presentation/resources/strings_manager.dart';
import 'package:temp/presentation/resources/values_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _registerViewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _mobileTextEditingController =
      TextEditingController();

  void _bind() {
    _registerViewModel.start();

    // add listeners
    _userNameTextEditingController.addListener(() =>
        _registerViewModel.setUserName(_userNameTextEditingController.text));
    _passwordTextEditingController.addListener(() =>
        _registerViewModel.setPassword(_passwordTextEditingController.text));
    _emailTextEditingController.addListener(
        () => _registerViewModel.setEmail(_emailTextEditingController.text));
    _mobileTextEditingController.addListener(() =>
        _registerViewModel.setMobileNumber(_mobileTextEditingController.text));
    _registerViewModel.isUserRegisteredInSuccessfullyStreamController.stream
        .listen((isLoggedIn) {
      if (isLoggedIn) {
        // navigate to main screen
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
      }
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
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
        stream: _registerViewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(
                  context, _getContentWidget(), _registerViewModel.register) ??
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
                    child: Image(image: AssetImage(ImageAssets.splashLogo))),
                const SizedBox(
                  height: AppSizeConstants.s28,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPaddingConstants.p28,
                      right: AppPaddingConstants.p28),
                  child: StreamBuilder<String?>(
                      stream: _registerViewModel.outputErrorUserName,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _userNameTextEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.username,
                              labelText: AppStrings.username,
                              errorText: snapshot.data),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSizeConstants.s18,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: AppPaddingConstants.p28,
                        right: AppPaddingConstants.p28),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: CountryCodePicker(
                              onChanged: (country) {
                                // update view model with code
                                _registerViewModel.setCountryCode(
                                    country.dialCode ?? Constants.dummyToken);
                              },
                              initialSelection: '+20',
                              favorite: const ['+39', 'FR', "+966"],
                              // optional. Shows only country name and flag
                              showCountryOnly: true,
                              hideMainText: true,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: true,
                            )),
                        Expanded(
                            flex: 4,
                            child: StreamBuilder<String?>(
                                stream:
                                    _registerViewModel.outputErrorMobileNumber,
                                builder: (context, snapshot) {
                                  return TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: _mobileTextEditingController,
                                    decoration: InputDecoration(
                                        hintText: AppStrings.mobileNumber,
                                        labelText: AppStrings.mobileNumber,
                                        errorText: snapshot.data),
                                  );
                                }))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSizeConstants.s18,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPaddingConstants.p28,
                      right: AppPaddingConstants.p28),
                  child: StreamBuilder<String?>(
                      stream: _registerViewModel.outputErrorEmail,
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
                  height: AppSizeConstants.s18,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPaddingConstants.p28,
                      right: AppPaddingConstants.p28),
                  child: StreamBuilder<String?>(
                      stream: _registerViewModel.outputErrorPassword,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordTextEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.password,
                              labelText: AppStrings.password,
                              errorText: snapshot.data),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSizeConstants.s18,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPaddingConstants.p28,
                      right: AppPaddingConstants.p28),
                  child: Container(
                    height: AppSizeConstants.s40,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(AppSizeConstants.s8)),
                        border: Border.all(color: ColorConstants.grey)),
                    child: GestureDetector(
                      child: _getMediaWidget(),
                      onTap: () {
                        _showPicker(context);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSizeConstants.s40,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPaddingConstants.p28,
                      right: AppPaddingConstants.p28),
                  child: StreamBuilder<bool>(
                      stream: _registerViewModel.outputAreAllInputsValid,
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: double.infinity,
                          height: AppSizeConstants.s40,
                          child: ElevatedButton(
                              onPressed: (snapshot.data ?? false)
                                  ? () {
                                      _registerViewModel.register();
                                    }
                                  : null,
                              child: const Text(AppStrings.register)),
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
                    child: Text(AppStrings.alreadyHaveAccount,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera),
                title: const Text(AppStrings.photoGallery),
                onTap: () {
                  _imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text(AppStrings.photoCamera),
                onTap: () {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
        });
  }

  _imageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _registerViewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _registerViewModel.setProfilePicture(File(image?.path ?? ""));
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppPaddingConstants.p8, right: AppPaddingConstants.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(child: Text(AppStrings.profilePicture)),
          Flexible(
              child: StreamBuilder<File>(
            stream: _registerViewModel.outputProfilePicture,
            builder: (context, snapshot) {
              return _imagePicketByUser(snapshot.data);
            },
          )),
          Flexible(child: SvgPicture.asset(ImageAssets.photoCameraIc))
        ],
      ),
    );
  }

  Widget _imagePicketByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      // return image
      return Image.file(image);
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    _registerViewModel.dispose();
    super.dispose();
  }
}
