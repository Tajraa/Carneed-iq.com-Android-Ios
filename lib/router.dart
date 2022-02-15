import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tajra/Ui/Points/checkout_points.dart';
import 'package:tajra/Ui/Points/points_page.dart';
import 'package:tajra/Ui/Points/points_products.dart';

import '/Ui/Cart/CheckoutPage.dart';
import '/Ui/Onboardings/OnBoardingScreen.dart';
import '/Ui/Profile/ProfilePage.dart';
import '/Ui/Profile/editProfile.dart';
import '/Ui/Search/pages/SearchPage.dart';
import './/Ui/Addresses/MyAddressesPage.dart';
import './/Ui/BasePage/BasePage.dart';
import './/Ui/Categories/CategoriesProductsPage.dart';

import './/Ui/Home/HomePage.dart';
import './/Ui/Notifications/NotificationsPage.dart';
import './/Ui/Orders/OrderDetailsPage.dart';
import './/Ui/Orders/OrdersPage.dart';
import './/Ui/ProductDetails/ProductDetailsPage.dart';
import './/Ui/Splash/SplashPage.dart';

import 'Ui/Auth/LoginPage.dart';

class AppRouter {
  static String currentRoute = "/";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentRoute = settings.name ?? "/";
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashPage());
      case '/login':
        return CupertinoPageRoute(builder: (_) => LoginPage());
      case '/base':
        return CupertinoPageRoute(builder: (_) => BasePage());
      case '/home':
        return CupertinoPageRoute(builder: (_) => HomePage());
      case '/categoryProducts':
        final args = settings.arguments as Map;
        return CupertinoPageRoute(
            builder: (_) => CategoryProductsPage(
                category: args["category"], selectedId: args["id"]));
      case '/productDetails':
        final argument = settings.arguments! as Map;
        final productId = argument["id"].toString();
        final forPointsSale = argument["forPointsSale"] ?? false;
        final goToOptions =
            argument["goToOptions"] != null ? argument["goToOptions"] : false;
        return MaterialPageRoute(
            builder: (_) => ProductsDetailsPage(
                  id: productId,
                  goToOptions: goToOptions,
                  forPointSale: forPointsSale,
                ));
      case '/editProfile':
        return CupertinoPageRoute(builder: (_) => EditProfilePage());
      case '/profile':
        return CupertinoPageRoute(builder: (_) => ProfilePage());
      case '/myAddresses':
        return CupertinoPageRoute(builder: (_) => MyAddressesPage());
      case '/orders':
        return CupertinoPageRoute(builder: (_) => OrdersPage());
      case '/change_points':
        // final minPoints = settings.arguments as int;
        return CupertinoPageRoute(builder: (_) => PointsProducts());
      case '/checkout_points':
        final args = settings.arguments as Map;
        final total = args["total"] as int;
        final productId = args["product_id"] as int;
        final options = args["options"] != null
            ? args["options"] as Map<String, String>
            : null;
        return CupertinoPageRoute(
            builder: (_) => CheckoutUsingPointsPage(
                total: total, productId: productId, options: options));
      case '/orderDetails':
        final orderId = settings.arguments as int;
        return CupertinoPageRoute(
            builder: (_) => OrderDetailsPage(
                  orderId: orderId,
                ));
      case '/notifications':
        return CupertinoPageRoute(builder: (_) => NotificationsPage());
      case '/onboard':
        return CupertinoPageRoute(builder: (_) => OnBoardingScreen());
      case '/search':
        return CupertinoPageRoute(builder: (_) => SearchPage());
      case '/myPoints':
        return CupertinoPageRoute(builder: (_) => MyPointsPage());
      case '/checkout':
        final args = settings.arguments as Map;
        return CupertinoPageRoute(
            builder: (_) => CheckoutPage(
                  total: args["total"],
                  discount: args["discount"],
                ));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
