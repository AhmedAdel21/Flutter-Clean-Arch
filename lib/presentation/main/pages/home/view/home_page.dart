import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:temp/app/di.dart';
import 'package:temp/domain/model/models.dart';
import 'package:temp/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:temp/presentation/main/pages/home/viewmodel/home_viewmodel.dart';
import 'package:temp/presentation/resources/color_manager.dart';
import 'package:temp/presentation/resources/routes_manager.dart';
import 'package:temp/presentation/resources/strings_manager.dart';
import 'package:temp/presentation/resources/values_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel _homeViewModel = instance<HomeViewModel>();
  _bind() {
    _homeViewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _homeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: StreamBuilder<FlowState>(
          stream: _homeViewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(
                    context, _getContentView(), _homeViewModel.start) ??
                _getContentView();
          },
        ),
      ),
    );
  }

  Widget _getContentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getBannerCarousel(),
        _getSection(AppStrings.services),
        _getServices(),
        _getSection(AppStrings.stores),
        _getStores(),
      ],
    );
  }

  Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPaddingConstants.p12,
        bottom: AppPaddingConstants.p2,
        right: AppPaddingConstants.p12,
        left: AppPaddingConstants.p12,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  Widget _getBannerCarousel() {
    return StreamBuilder<List<BannerAd>>(
      stream: _homeViewModel.outputBanners,
      builder: (context, snapshot) {
        return _getBannersWidget(snapshot.data);
      },
    );
  }

  Widget _getBannersWidget(List<BannerAd>? banners) {
    if (banners != null) {
      return CarouselSlider(
        options: CarouselOptions(
          height: AppSizeConstants.s90,
          autoPlay: true,
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
        ),
        items: banners.map((banner) {
          return SizedBox(
            width: double.infinity,
            child: Card(
              elevation: AppSizeConstants.s1_5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizeConstants.s12),
                side: const BorderSide(
                    color: ColorConstants.primary, width: AppSizeConstants.s1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizeConstants.s12),
                child: Image.network(
                  banner.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _getServices() {
    return StreamBuilder<List<Service>>(
      stream: _homeViewModel.outputService,
      builder: (context, snapshot) {
        return _getServicesWidget(snapshot.data);
      },
    );
  }

  Widget _getServicesWidget(List<Service>? services) {
    if (services != null) {
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppPaddingConstants.p12),
        child: Container(
          height: AppSizeConstants.s140,
          margin: const EdgeInsets.symmetric(vertical: AppMarginConstants.m12),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: services.map((service) {
              return Card(
                elevation: AppSizeConstants.s4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizeConstants.s12),
                  side: const BorderSide(
                      color: ColorConstants.primary,
                      width: AppSizeConstants.s1),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSizeConstants.s12),
                        child: Image.network(
                          service.image,
                          fit: BoxFit.cover,
                          width: AppSizeConstants.s100,
                          height: AppSizeConstants.s100,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: AppPaddingConstants.p2),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              service.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.caption,
                            )),
                      ),
                    ]),
              );
            }).toList(),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _getStores() {
    return StreamBuilder<List<Store>>(
      stream: _homeViewModel.outputStores,
      builder: (context, snapshot) {
        return _getStoresWidget(snapshot.data);
      },
    );
  }

  Widget _getStoresWidget(List<Store>? stores) {
    if (stores != null) {
      return Padding(
        padding: const EdgeInsets.only(
          top: AppPaddingConstants.p12,
          right: AppPaddingConstants.p12,
          left: AppPaddingConstants.p12,
        ),
        child: Flex(direction: Axis.vertical, children: [
          GridView.count(
            crossAxisCount: AppSizeConstants.s2.toInt(),
            crossAxisSpacing: AppSizeConstants.s8,
            mainAxisSpacing: AppSizeConstants.s8,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(stores.length, (index) {
              return InkWell(
                onTap: () {
                  // navigate to store details screen
                  Navigator.of(context).pushNamed(Routes.storeDetailsRoute);
                },
                child: Card(
                  elevation: AppSizeConstants.s4,
                  child: Image.network(
                    stores[index].image,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
          )
        ]),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
