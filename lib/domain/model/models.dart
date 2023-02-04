// OnBoarding models

class SliderObject {
  String title;
  String subTitle;
  String image;

  SliderObject(this.title, this.subTitle, this.image);
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSliders;
  int currentIndex;

  SliderViewObject(this.sliderObject, this.numOfSliders, this.currentIndex);
}

// login models

class Customer {
  String id;
  String name;
  int numOfNotifications;

  Customer(this.id, this.name, this.numOfNotifications);
}

class Contact {
  int phone;
  String email;
  String link;

  Contact(this.phone, this.email, this.link);
}

class Authentication {
  Customer? customer;
  Contact? contacts;

  Authentication(this.customer, this.contacts);
}

class ForgetPasswordSupportMessage {
  String supportMessage;

  ForgetPasswordSupportMessage(this.supportMessage);
}

class Store {
  int id;
  String title;
  String image;

  Store(this.id, this.title, this.image);
}

class Service {
  int id;
  String title;
  String image;

  Service(this.id, this.title, this.image);
}

class BannerAd {
  int id;
  String title;
  String image;
  String link;

  BannerAd(this.id, this.title, this.image, this.link);
}

class HomeData {
  List<Service> services;
  List<BannerAd> banners;
  List<Store> stores;

  HomeData(this.services, this.banners, this.stores);
}

class HomeObject {
  HomeData data;

  HomeObject(this.data);
}
