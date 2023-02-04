import 'package:flutter/cupertino.dart';
import 'package:temp/app/constants.dart';
import 'package:temp/data/response/responses.dart';
import 'package:temp/domain/model/models.dart';
import 'package:temp/app/extensions.dart';

extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(
        this?.id.orEmpty() ?? Constants.empty,
        this?.name.orEmpty() ?? Constants.empty,
        this?.numOfNotifications.orMinusOne() ?? Constants.minusOne);
  }
}

extension ContactResponseMapper on ContactResponse? {
  Contact toDomain() {
    return Contact(
        this?.phone.orMinusOne() ?? Constants.minusOne,
        this?.email.orEmpty() ?? Constants.empty,
        this?.link.orEmpty() ?? Constants.empty);
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse? {
  Authentication toDomain() {
    return Authentication(this?.customer.toDomain(), this?.contacts.toDomain());
  }
}

extension ForgetPasswordSupportMessageResponseMapper
    on ForgetPasswordSupportMessageResponse {
  ForgetPasswordSupportMessage toDomain() {
    return ForgetPasswordSupportMessage(supportMessage.orEmpty());
  }
}

extension ServiceResponseMapper on ServiceResponse? {
  Service toDomain() {
    return Service(
        this?.id.orMinusOne() ?? Constants.minusOne,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty);
  }
}

extension StoreResponseMapper on StoreResponse? {
  Store toDomain() {
    return Store(
        this?.id.orMinusOne() ?? Constants.minusOne,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty);
  }
}

extension BannerResponseMapper on BannerResponse? {
  BannerAd toDomain() {
    return BannerAd(
        this?.id.orMinusOne() ?? Constants.minusOne,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty,
        this?.link.orEmpty() ?? Constants.empty);
  }
}

extension HomeResponseMapper on HomeResponse? {
  HomeObject toDomain() {
    List<Service> services = this
            ?.data
            ?.services
            ?.map((serviceResponse) => serviceResponse.toDomain())
            .toList() ??
        List.empty(growable: true).cast<Service>().toList();

    List<BannerAd> banners = this
            ?.data
            ?.banners
            ?.map((bannerResponse) => bannerResponse.toDomain())
            .toList() ??
        List.empty(growable: true).cast<BannerAd>().toList();

    List<Store> stores = this
            ?.data
            ?.stores
            ?.map((storeResponse) => storeResponse.toDomain())
            .toList() ??
        List.empty(growable: true).cast<Store>().toList();

    return HomeObject(HomeData(services, banners, stores));
  }
}
