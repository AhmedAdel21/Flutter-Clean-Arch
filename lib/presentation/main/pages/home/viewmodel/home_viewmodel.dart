import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:temp/domain/model/models.dart';
import 'package:temp/domain/usecase/home_usecase.dart';
import 'package:temp/presentation/base/base_viewmodel.dart';
import 'package:temp/presentation/common/state_renderer/state_renderer.dart';
import 'package:temp/presentation/common/state_renderer/state_renderer_impl.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInput, HomeViewModelOutput {
  final StreamController<List<BannerAd>> _bannerStreamController =
      BehaviorSubject<List<BannerAd>>();
  final StreamController<List<Service>> _serviceStreamController =
      BehaviorSubject<List<Service>>();
  final StreamController<List<Store>> _storeStreamController =
      BehaviorSubject<List<Store>>();

  final HomeUseCase _homeUseCase;
  HomeViewModel(this._homeUseCase);
  @override
  void start() async {
    await _getHomeData();
  }

  @override
  void dispose() {
    _bannerStreamController.close();
    _serviceStreamController.close();
    _storeStreamController.close();
    super.dispose();
  }

  Future<void> _getHomeData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));

    (await _homeUseCase.execute(null)).fold(
      (left) {
        // left -> failure
        inputState.add(ErrorState(
            stateRendererType: StateRendererType.popupErrorState,
            message: left.message));
      },
      (homeObject) {
        // right -> data  (success)
        inputState.add(ContentState());
        inputBanners.add(homeObject.data.banners);
        inputService.add(homeObject.data.services);
        inputStores.add(homeObject.data.stores);
        // navigate to home screen
      },
    );
  }

  // -- inputs
  @override
  Sink<List<BannerAd>> get inputBanners => _bannerStreamController.sink;

  @override
  Sink<List<Service>> get inputService => _serviceStreamController.sink;

  @override
  Sink<List<Store>> get inputStores => _storeStreamController.sink;

  // -- outputs
  @override
  Stream<List<BannerAd>> get outputBanners =>
      _bannerStreamController.stream.map((banners) => banners);

  @override
  Stream<List<Service>> get outputService =>
      _serviceStreamController.stream.map((services) => services);

  @override
  Stream<List<Store>> get outputStores =>
      _storeStreamController.stream.map((stores) => stores);
}

abstract class HomeViewModelInput {
  Sink<List<Store>> get inputStores;
  Sink<List<Service>> get inputService;
  Sink<List<BannerAd>> get inputBanners;
}

abstract class HomeViewModelOutput {
  Stream<List<Store>> get outputStores;
  Stream<List<Service>> get outputService;
  Stream<List<BannerAd>> get outputBanners;
}
