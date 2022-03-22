import 'package:progiom_cms/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';


class PrefsHelper {
  PrefsHelper._();
  SharedPreferences? _preferences;

  static final PrefsHelper pref = PrefsHelper._();

  bool isSecure = true;
  Future<SharedPreferences> get _getSharedPref async {
    if (_preferences != null)
      return _preferences!;
    else {
      _preferences = await SharedPreferences.getInstance();

      return _preferences!;
    }
  }

 
  saveLangToSharedPref(String lang) async {
    final p = await (_getSharedPref);
    return p.setString(AuthConstants.Language, lang);
  }

  loadLangFromSharedPref() async {
    final p = await (_getSharedPref);
    return p.getString(AuthConstants.Language);
  }

  saveCurrencyToSharedPref(String currency) async {
    final p = await (_getSharedPref);
    return p.setString(AuthConstants.Currency, currency);
  }

  loadCurrencyFromSharedPref() async {
    final p = await (_getSharedPref);
    print('hoho + ${p.getString(AuthConstants.Currency)}');
    return p.getString(AuthConstants.Currency);
  }
 

  // Future<User> getUser() async {
  //   final p = await (_getSharedPref as Future<SharedPreferences>);
  //   String name = p.getString(NAME) ?? "";
  //   String email = p.getString(EMAIL) ?? "";

  //   int? id = p.getInt(ID);
  //   String address = p.getString(ADDRESS) ?? "";
  //   String mobile = p.getString(MOBILE) ?? "";
  //   String webSite = p.getString(WEBSITE) ?? "";
  //   String slug = p.getString(SLUG) ?? "";

  //   String profile_photo_url = p.getString(PROFILE_IMAGE) ?? "";
  //   String cover_image = p.getString(COVER_IMAGE) ?? "";
  //   User user = User(
  //       // name: name,
  //       // email: email,
  //       // slug: slug,
  //       // website: webSite,
  //       // profile_photo_url: profile_photo_url,
  //       // cover_image: cover_image,
  //       // id: id,
  //       // address: address,
  //       // mobile: mobile,
  //       );
  //   return user;
  // }

  // Future<void> saveUser(User user) async {
  //   final p = await _getSharedPref;

  //   // p.setString(NAME, user.name);
  //   // p.setString(EMAIL, user.email);
  //   // p.setString(MOBILE, user.mobile ?? "");
  //   // p.setInt(ID, user.id);
  //   // p.setString(WEBSITE, user.website ?? "");
  //   // p.setString(ADDRESS, user.address ?? "");
  //   // p.setString(SLUG, user.slug ?? "");
  //   // p.setString(PROFILE_IMAGE, user.profile_photo_url);
  //   // p.setString(COVER_IMAGE, user.cover_image ?? "");
  //   // await saveToken(
  //   //     user.access_token); // here in register no expires time coming
  //   return;
  // }

  Future<int?> getUserId() async {
    final p = await (_getSharedPref);
    return (p.getInt(ID));
  }

  Future<void> saveToken(String token, [int? expiresIn]) async {
    final p = await (_getSharedPref);
    p.setString(TOKEN, token);
    if (expiresIn != null) p.setInt(EXPIRESIN, expiresIn);
  }
}
