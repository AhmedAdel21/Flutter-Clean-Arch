// OnBoarding models
import 'package:temp/data/response/responses.dart';

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
  Customer customer;
  Contact contacts;

  Authentication(this.customer, this.contacts);
}
