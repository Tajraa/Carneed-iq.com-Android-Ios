// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `تسجيل الدخول`
  String get login {
    return Intl.message(
      'تسجيل الدخول',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `أنشئ حساب`
  String get singup {
    return Intl.message(
      'أنشئ حساب',
      name: 'singup',
      desc: '',
      args: [],
    );
  }

  /// `إعادة تعيين كلمة المرور`
  String get change_password {
    return Intl.message(
      'إعادة تعيين كلمة المرور',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `أدخل عنوان البريد الإلكتروني الذي استخدمته لإنشاء حسابك وسنرسل لك رابطًا عبر البريد الإلكتروني لإعادة تعيين  كلمة المرور الخاصة بك`
  String get change_password_message {
    return Intl.message(
      'أدخل عنوان البريد الإلكتروني الذي استخدمته لإنشاء حسابك وسنرسل لك رابطًا عبر البريد الإلكتروني لإعادة تعيين  كلمة المرور الخاصة بك',
      name: 'change_password_message',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور الجديدة`
  String get new_password {
    return Intl.message(
      'كلمة المرور الجديدة',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد كلمة المرور`
  String get confirm_password {
    return Intl.message(
      'تأكيد كلمة المرور',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `البريد الالكتروني`
  String get e_mail {
    return Intl.message(
      'البريد الالكتروني',
      name: 'e_mail',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور`
  String get password {
    return Intl.message(
      'كلمة المرور',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `متابعة`
  String get continuee {
    return Intl.message(
      'متابعة',
      name: 'continuee',
      desc: '',
      args: [],
    );
  }

  /// `شرح`
  String get reportDescription {
    return Intl.message(
      'شرح',
      name: 'reportDescription',
      desc: '',
      args: [],
    );
  }

  /// `هل نسيت كلمة المرور ؟`
  String get forget_password {
    return Intl.message(
      'هل نسيت كلمة المرور ؟',
      name: 'forget_password',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال الرمز المرسل للبريد الالكتروني`
  String get enter_code {
    return Intl.message(
      'الرجاء إدخال الرمز المرسل للبريد الالكتروني',
      name: 'enter_code',
      desc: '',
      args: [],
    );
  }

  /// `  أو سجل الدخول عن طريق  `
  String get sign_in_with {
    return Intl.message(
      '  أو سجل الدخول عن طريق  ',
      name: 'sign_in_with',
      desc: '',
      args: [],
    );
  }

  /// `  أو أنشئ حساب عن طريق  `
  String get sign_up_with {
    return Intl.message(
      '  أو أنشئ حساب عن طريق  ',
      name: 'sign_up_with',
      desc: '',
      args: [],
    );
  }

  /// `مستخدم جديد؟`
  String get new_user {
    return Intl.message(
      'مستخدم جديد؟',
      name: 'new_user',
      desc: '',
      args: [],
    );
  }

  /// `لديك حساب ؟ `
  String get haveAnAccount {
    return Intl.message(
      'لديك حساب ؟ ',
      name: 'haveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `أنشئ حساب `
  String get create_account {
    return Intl.message(
      'أنشئ حساب ',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// ` و `
  String get and {
    return Intl.message(
      ' و ',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء التأكد من رقم الهاتف`
  String get mobileValidator {
    return Intl.message(
      'الرجاء التأكد من رقم الهاتف',
      name: 'mobileValidator',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور غير متطابقة`
  String get passwordConfirm {
    return Intl.message(
      'كلمة المرور غير متطابقة',
      name: 'passwordConfirm',
      desc: '',
      args: [],
    );
  }

  /// `يجب أن تحوي 8 محارف على الأقل`
  String get passwordValidator {
    return Intl.message(
      'يجب أن تحوي 8 محارف على الأقل',
      name: 'passwordValidator',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال الاسم الكامل`
  String get nameRequired {
    return Intl.message(
      'الرجاء إدخال الاسم الكامل',
      name: 'nameRequired',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال البريد الإلكتروني`
  String get emailRequired {
    return Intl.message(
      'الرجاء إدخال البريد الإلكتروني',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال بريد الكتروني صالح`
  String get emailValidator {
    return Intl.message(
      'الرجاء إدخال بريد الكتروني صالح',
      name: 'emailValidator',
      desc: '',
      args: [],
    );
  }

  /// `الدخول كضيف`
  String get continueAsGuest {
    return Intl.message(
      'الدخول كضيف',
      name: 'continueAsGuest',
      desc: '',
      args: [],
    );
  }

  /// `هنا`
  String get here {
    return Intl.message(
      'هنا',
      name: 'here',
      desc: '',
      args: [],
    );
  }

  /// `أهلا بك`
  String get welcome {
    return Intl.message(
      'أهلا بك',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء تسجيل الدخول`
  String get please_sign_in {
    return Intl.message(
      'الرجاء تسجيل الدخول',
      name: 'please_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء انشاء حساب`
  String get please_sign_up {
    return Intl.message(
      'الرجاء انشاء حساب',
      name: 'please_sign_up',
      desc: '',
      args: [],
    );
  }

  /// `أنت جاهز للإنطلاق`
  String get readyToGo {
    return Intl.message(
      'أنت جاهز للإنطلاق',
      name: 'readyToGo',
      desc: '',
      args: [],
    );
  }

  /// `غوغل`
  String get google {
    return Intl.message(
      'غوغل',
      name: 'google',
      desc: '',
      args: [],
    );
  }

  /// `فيسبوك`
  String get facebook {
    return Intl.message(
      'فيسبوك',
      name: 'facebook',
      desc: '',
      args: [],
    );
  }

  /// `ابدأ الأن`
  String get startNow {
    return Intl.message(
      'ابدأ الأن',
      name: 'startNow',
      desc: '',
      args: [],
    );
  }

  /// `نشكرك على الوقت الذي أمضيته في إنشاء حسابك. الآن هذا هو الجزء الممتع ، دعنا نستكشف التطبيق.`
  String get thanksForTime {
    return Intl.message(
      'نشكرك على الوقت الذي أمضيته في إنشاء حسابك. الآن هذا هو الجزء الممتع ، دعنا نستكشف التطبيق.',
      name: 'thanksForTime',
      desc: '',
      args: [],
    );
  }

  /// `ابحث هنا`
  String get searchHere {
    return Intl.message(
      'ابحث هنا',
      name: 'searchHere',
      desc: '',
      args: [],
    );
  }

  /// `المميزات`
  String get features {
    return Intl.message(
      'المميزات',
      name: 'features',
      desc: '',
      args: [],
    );
  }

  /// `التقيمات`
  String get rates {
    return Intl.message(
      'التقيمات',
      name: 'rates',
      desc: '',
      args: [],
    );
  }

  /// `المكونات`
  String get ingredients {
    return Intl.message(
      'المكونات',
      name: 'ingredients',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد تقييمات بعد`
  String get noReviews {
    return Intl.message(
      'لا يوجد تقييمات بعد',
      name: 'noReviews',
      desc: '',
      args: [],
    );
  }

  /// `إضافة الى السلة`
  String get addToCart {
    return Intl.message(
      'إضافة الى السلة',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `قائمة المنتجات`
  String get productsList {
    return Intl.message(
      'قائمة المنتجات',
      name: 'productsList',
      desc: '',
      args: [],
    );
  }

  /// `البحث الشائع`
  String get commonSearch {
    return Intl.message(
      'البحث الشائع',
      name: 'commonSearch',
      desc: '',
      args: [],
    );
  }

  /// `تاريخ البحث`
  String get searchHistory {
    return Intl.message(
      'تاريخ البحث',
      name: 'searchHistory',
      desc: '',
      args: [],
    );
  }

  /// `الفلتر`
  String get filter {
    return Intl.message(
      'الفلتر',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `مسح`
  String get delete {
    return Intl.message(
      'مسح',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `السعر`
  String get price {
    return Intl.message(
      'السعر',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `التصنيف`
  String get category {
    return Intl.message(
      'التصنيف',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `الماركة`
  String get brand {
    return Intl.message(
      'الماركة',
      name: 'brand',
      desc: '',
      args: [],
    );
  }

  /// `التقيم`
  String get rate {
    return Intl.message(
      'التقيم',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `تطبيق الفلتر`
  String get applyFilter {
    return Intl.message(
      'تطبيق الفلتر',
      name: 'applyFilter',
      desc: '',
      args: [],
    );
  }

  /// `السلة`
  String get cart {
    return Intl.message(
      'السلة',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `تطبيق`
  String get submit {
    return Intl.message(
      'تطبيق',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `شراء السلة`
  String get checkoutCart {
    return Intl.message(
      'شراء السلة',
      name: 'checkoutCart',
      desc: '',
      args: [],
    );
  }

  /// `الإجمالي`
  String get total {
    return Intl.message(
      'الإجمالي',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `الخصم`
  String get sale {
    return Intl.message(
      'الخصم',
      name: 'sale',
      desc: '',
      args: [],
    );
  }

  /// `العدد الكلي`
  String get totalNumber {
    return Intl.message(
      'العدد الكلي',
      name: 'totalNumber',
      desc: '',
      args: [],
    );
  }

  /// `إضافة كوبون`
  String get addCoupon {
    return Intl.message(
      'إضافة كوبون',
      name: 'addCoupon',
      desc: '',
      args: [],
    );
  }

  /// `عدد المنتجات : `
  String get numberOfProducts {
    return Intl.message(
      'عدد المنتجات : ',
      name: 'numberOfProducts',
      desc: '',
      args: [],
    );
  }

  /// `أدخل الكود هنا`
  String get enterCouponHere {
    return Intl.message(
      'أدخل الكود هنا',
      name: 'enterCouponHere',
      desc: '',
      args: [],
    );
  }

  /// `العناوين`
  String get addresses {
    return Intl.message(
      'العناوين',
      name: 'addresses',
      desc: '',
      args: [],
    );
  }

  /// `العنوان`
  String get address {
    return Intl.message(
      'العنوان',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `إضافة عنوان`
  String get addAddress {
    return Intl.message(
      'إضافة عنوان',
      name: 'addAddress',
      desc: '',
      args: [],
    );
  }

  /// `طريقة الدفع`
  String get paymentMethod {
    return Intl.message(
      'طريقة الدفع',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `بطاقة ائتمانية`
  String get creditCard {
    return Intl.message(
      'بطاقة ائتمانية',
      name: 'creditCard',
      desc: '',
      args: [],
    );
  }

  /// `الدفع عند الباب`
  String get onDelivery {
    return Intl.message(
      'الدفع عند الباب',
      name: 'onDelivery',
      desc: '',
      args: [],
    );
  }

  /// `اسم البطاقة`
  String get cardName {
    return Intl.message(
      'اسم البطاقة',
      name: 'cardName',
      desc: '',
      args: [],
    );
  }

  /// `رقم البطاقة`
  String get cardNumber {
    return Intl.message(
      'رقم البطاقة',
      name: 'cardNumber',
      desc: '',
      args: [],
    );
  }

  /// `تاريخ الإنتهاء`
  String get expiryDate {
    return Intl.message(
      'تاريخ الإنتهاء',
      name: 'expiryDate',
      desc: '',
      args: [],
    );
  }

  /// `الكود`
  String get code {
    return Intl.message(
      'الكود',
      name: 'code',
      desc: '',
      args: [],
    );
  }

  /// `ادفع`
  String get pay {
    return Intl.message(
      'ادفع',
      name: 'pay',
      desc: '',
      args: [],
    );
  }

  /// `شكرا لك. تم وضع طلبك بنجاح.`
  String get checkoutSuccess_subtitle {
    return Intl.message(
      'شكرا لك. تم وضع طلبك بنجاح.',
      name: 'checkoutSuccess_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `تمت عملية الشراء بنجاح`
  String get checkoutSuccess {
    return Intl.message(
      'تمت عملية الشراء بنجاح',
      name: 'checkoutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `أكمل التسوّق`
  String get continueShopping {
    return Intl.message(
      'أكمل التسوّق',
      name: 'continueShopping',
      desc: '',
      args: [],
    );
  }

  /// `طلباتي`
  String get orderHistory {
    return Intl.message(
      'طلباتي',
      name: 'orderHistory',
      desc: '',
      args: [],
    );
  }

  /// `قيد الإنتظار`
  String get waitings {
    return Intl.message(
      'قيد الإنتظار',
      name: 'waitings',
      desc: '',
      args: [],
    );
  }

  /// `تعقب الطلب`
  String get trackOrder {
    return Intl.message(
      'تعقب الطلب',
      name: 'trackOrder',
      desc: '',
      args: [],
    );
  }

  /// `إلغاء الطلب`
  String get cancelOrder {
    return Intl.message(
      'إلغاء الطلب',
      name: 'cancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `رقم السلة :`
  String get orderNumber {
    return Intl.message(
      'رقم السلة :',
      name: 'orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `منتجات`
  String get products {
    return Intl.message(
      'منتجات',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `قيم الطلب`
  String get rateOrder {
    return Intl.message(
      'قيم الطلب',
      name: 'rateOrder',
      desc: '',
      args: [],
    );
  }

  /// `طلباتي السابقة`
  String get deliveredOrders {
    return Intl.message(
      'طلباتي السابقة',
      name: 'deliveredOrders',
      desc: '',
      args: [],
    );
  }

  /// `الملف الشخصي`
  String get profile {
    return Intl.message(
      'الملف الشخصي',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `الصورة الشخصية`
  String get profileImage {
    return Intl.message(
      'الصورة الشخصية',
      name: 'profileImage',
      desc: '',
      args: [],
    );
  }

  /// `المعلومات الشخصية`
  String get personalInfo {
    return Intl.message(
      'المعلومات الشخصية',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `الاسم الكامل`
  String get fullName {
    return Intl.message(
      'الاسم الكامل',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `الإشعارات`
  String get notifications {
    return Intl.message(
      'الإشعارات',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `الإعدادات`
  String get settings {
    return Intl.message(
      'الإعدادات',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `إشعارات التطبيق`
  String get appNotifications {
    return Intl.message(
      'إشعارات التطبيق',
      name: 'appNotifications',
      desc: '',
      args: [],
    );
  }

  /// `إشعارات التخفيضات`
  String get salesNotifications {
    return Intl.message(
      'إشعارات التخفيضات',
      name: 'salesNotifications',
      desc: '',
      args: [],
    );
  }

  /// `إشعارات العروض`
  String get offersNotifications {
    return Intl.message(
      'إشعارات العروض',
      name: 'offersNotifications',
      desc: '',
      args: [],
    );
  }

  /// `اللغة`
  String get language {
    return Intl.message(
      'اللغة',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `مشاركة التطبيق`
  String get shareApp {
    return Intl.message(
      'مشاركة التطبيق',
      name: 'shareApp',
      desc: '',
      args: [],
    );
  }

  /// `سياسة الخصوصية`
  String get privcy {
    return Intl.message(
      'سياسة الخصوصية',
      name: 'privcy',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الخروج`
  String get signOut {
    return Intl.message(
      'تسجيل الخروج',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `الدعم الفني`
  String get technicalSupport {
    return Intl.message(
      'الدعم الفني',
      name: 'technicalSupport',
      desc: '',
      args: [],
    );
  }

  /// `رقم الإصدار`
  String get appVersion {
    return Intl.message(
      'رقم الإصدار',
      name: 'appVersion',
      desc: '',
      args: [],
    );
  }

  /// `التعليق`
  String get comment {
    return Intl.message(
      'التعليق',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `اترك تعليقك هنا`
  String get leaveAComment {
    return Intl.message(
      'اترك تعليقك هنا',
      name: 'leaveAComment',
      desc: '',
      args: [],
    );
  }

  /// `تقييم`
  String get rateIt {
    return Intl.message(
      'تقييم',
      name: 'rateIt',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد اتصال بالانترنت`
  String get noInternet {
    return Intl.message(
      'لا يوجد اتصال بالانترنت',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `حاول مجدداً`
  String get tryAgain {
    return Intl.message(
      'حاول مجدداً',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `البريد الإلكتروني أو كلمة المرور غير صحيحة`
  String get emailOrPasswordWrong {
    return Intl.message(
      'البريد الإلكتروني أو كلمة المرور غير صحيحة',
      name: 'emailOrPasswordWrong',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور غير متطابقة.`
  String get passwordConfirmValidator {
    return Intl.message(
      'كلمة المرور غير متطابقة.',
      name: 'passwordConfirmValidator',
      desc: '',
      args: [],
    );
  }

  /// `تمت اضافة المنتج الى السلة.`
  String get addedToCart {
    return Intl.message(
      'تمت اضافة المنتج الى السلة.',
      name: 'addedToCart',
      desc: '',
      args: [],
    );
  }

  /// `المفضلة`
  String get myFavorites {
    return Intl.message(
      'المفضلة',
      name: 'myFavorites',
      desc: '',
      args: [],
    );
  }

  /// `السلة فارغة!`
  String get cartEmpty {
    return Intl.message(
      'السلة فارغة!',
      name: 'cartEmpty',
      desc: '',
      args: [],
    );
  }

  /// `ملاحظات`
  String get notes {
    return Intl.message(
      'ملاحظات',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إضافة عنوان.`
  String get mustAddAddress {
    return Intl.message(
      'الرجاء إضافة عنوان.',
      name: 'mustAddAddress',
      desc: '',
      args: [],
    );
  }

  /// `المدونة`
  String get blogs {
    return Intl.message(
      'المدونة',
      name: 'blogs',
      desc: '',
      args: [],
    );
  }

  /// `تغيير العنوان`
  String get change_address {
    return Intl.message(
      'تغيير العنوان',
      name: 'change_address',
      desc: '',
      args: [],
    );
  }

  /// `أحدث المنتجات`
  String get recent_products {
    return Intl.message(
      'أحدث المنتجات',
      name: 'recent_products',
      desc: '',
      args: [],
    );
  }

  /// `منتجات جديدة`
  String get featured_products {
    return Intl.message(
      'منتجات جديدة',
      name: 'featured_products',
      desc: '',
      args: [],
    );
  }

  /// `اكتشف`
  String get discover {
    return Intl.message(
      'اكتشف',
      name: 'discover',
      desc: '',
      args: [],
    );
  }

  /// `تسوق الآن`
  String get shop_now {
    return Intl.message(
      'تسوق الآن',
      name: 'shop_now',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الدخول`
  String get not_loggedin_title {
    return Intl.message(
      'تسجيل الدخول',
      name: 'not_loggedin_title',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء تسجيل الدخول للمتابعة .`
  String get not_loggedin_content {
    return Intl.message(
      'الرجاء تسجيل الدخول للمتابعة .',
      name: 'not_loggedin_content',
      desc: '',
      args: [],
    );
  }

  /// `رجوع`
  String get back {
    return Intl.message(
      'رجوع',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `الكل`
  String get all {
    return Intl.message(
      'الكل',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `لماذا لا تذهبين وتملئينه بأدوات التجميل الرائعة؟ `
  String get cart_empty_subtitle {
    return Intl.message(
      'لماذا لا تذهبين وتملئينه بأدوات التجميل الرائعة؟ ',
      name: 'cart_empty_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `سعر السلة : `
  String get orderPrice {
    return Intl.message(
      'سعر السلة : ',
      name: 'orderPrice',
      desc: '',
      args: [],
    );
  }

  /// `تاريخ الطلب : `
  String get dateOfOrder {
    return Intl.message(
      'تاريخ الطلب : ',
      name: 'dateOfOrder',
      desc: '',
      args: [],
    );
  }

  /// `تعديل الملف الشخصي`
  String get editProfile {
    return Intl.message(
      'تعديل الملف الشخصي',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `اسم العنوان:`
  String get addressName {
    return Intl.message(
      'اسم العنوان:',
      name: 'addressName',
      desc: '',
      args: [],
    );
  }

  /// `البلد:`
  String get country {
    return Intl.message(
      'البلد:',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `المدينة:`
  String get city {
    return Intl.message(
      'المدينة:',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `العنوان بالتفصيل`
  String get addressDetails {
    return Intl.message(
      'العنوان بالتفصيل',
      name: 'addressDetails',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد عناوين`
  String get noAddresses {
    return Intl.message(
      'لا يوجد عناوين',
      name: 'noAddresses',
      desc: '',
      args: [],
    );
  }

  /// `اضغط مرتين للخروج`
  String get click_twice {
    return Intl.message(
      'اضغط مرتين للخروج',
      name: 'click_twice',
      desc: '',
      args: [],
    );
  }

  /// `ترتيب حسب`
  String get sort_by {
    return Intl.message(
      'ترتيب حسب',
      name: 'sort_by',
      desc: '',
      args: [],
    );
  }

  /// `الأقل سعراً`
  String get less_price {
    return Intl.message(
      'الأقل سعراً',
      name: 'less_price',
      desc: '',
      args: [],
    );
  }

  /// `الأعلى سعراً`
  String get high_price {
    return Intl.message(
      'الأعلى سعراً',
      name: 'high_price',
      desc: '',
      args: [],
    );
  }

  /// `الأحدث`
  String get newest {
    return Intl.message(
      'الأحدث',
      name: 'newest',
      desc: '',
      args: [],
    );
  }

  /// `الأقدم`
  String get oldest {
    return Intl.message(
      'الأقدم',
      name: 'oldest',
      desc: '',
      args: [],
    );
  }

  /// `الغاء الطلب ؟`
  String get cancel_order {
    return Intl.message(
      'الغاء الطلب ؟',
      name: 'cancel_order',
      desc: '',
      args: [],
    );
  }

  /// `نعم`
  String get yes {
    return Intl.message(
      'نعم',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `لا`
  String get no {
    return Intl.message(
      'لا',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `هل أنت متأكد.`
  String get are_you_sure {
    return Intl.message(
      'هل أنت متأكد.',
      name: 'are_you_sure',
      desc: '',
      args: [],
    );
  }

  /// `إلغاء`
  String get cancel {
    return Intl.message(
      'إلغاء',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `ملغي`
  String get canceled {
    return Intl.message(
      'ملغي',
      name: 'canceled',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الدخول باستخدام Apple`
  String get sign_with_apple {
    return Intl.message(
      'تسجيل الدخول باستخدام Apple',
      name: 'sign_with_apple',
      desc: '',
      args: [],
    );
  }

  /// `عرض السلة`
  String get show_order {
    return Intl.message(
      'عرض السلة',
      name: 'show_order',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد نتائج`
  String get no_result {
    return Intl.message(
      'لا يوجد نتائج',
      name: 'no_result',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد اشعارات`
  String get no_notifications {
    return Intl.message(
      'لا يوجد اشعارات',
      name: 'no_notifications',
      desc: '',
      args: [],
    );
  }

  /// `تخطي`
  String get skip {
    return Intl.message(
      'تخطي',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `التالي`
  String get next {
    return Intl.message(
      'التالي',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `تعديل`
  String get edit {
    return Intl.message(
      'تعديل',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `سجَل دخول لتستفيد من مزايا التطبيق`
  String get by_login {
    return Intl.message(
      'سجَل دخول لتستفيد من مزايا التطبيق',
      name: 'by_login',
      desc: '',
      args: [],
    );
  }

  /// `نجاح`
  String get success {
    return Intl.message(
      'نجاح',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `تنبيه`
  String get warning {
    return Intl.message(
      'تنبيه',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `تحذير`
  String get danger {
    return Intl.message(
      'تحذير',
      name: 'danger',
      desc: '',
      args: [],
    );
  }

  /// `معلومة`
  String get info {
    return Intl.message(
      'معلومة',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `إختيار دولة`
  String get select_country {
    return Intl.message(
      'إختيار دولة',
      name: 'select_country',
      desc: '',
      args: [],
    );
  }

  /// `يرجى ادخال الاسم.`
  String get address_name_required {
    return Intl.message(
      'يرجى ادخال الاسم.',
      name: 'address_name_required',
      desc: '',
      args: [],
    );
  }

  /// `عناويني`
  String get my_addresses {
    return Intl.message(
      'عناويني',
      name: 'my_addresses',
      desc: '',
      args: [],
    );
  }

  /// `عناويني المسجلة`
  String get my_registered_addresses {
    return Intl.message(
      'عناويني المسجلة',
      name: 'my_registered_addresses',
      desc: '',
      args: [],
    );
  }

  /// `في تطبيق كارنيد`
  String get to_carneed {
    return Intl.message(
      'في تطبيق كارنيد',
      name: 'to_carneed',
      desc: '',
      args: [],
    );
  }

  /// `ليس لديك حساب ؟`
  String get dont_have_account {
    return Intl.message(
      'ليس لديك حساب ؟',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `الرئيسية`
  String get home {
    return Intl.message(
      'الرئيسية',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `التصنيفات`
  String get categories {
    return Intl.message(
      'التصنيفات',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `حسابي`
  String get my_account {
    return Intl.message(
      'حسابي',
      name: 'my_account',
      desc: '',
      args: [],
    );
  }

  /// `طلب عبر `
  String get order_by {
    return Intl.message(
      'طلب عبر ',
      name: 'order_by',
      desc: '',
      args: [],
    );
  }

  /// `إرسال الى `
  String get send_to {
    return Intl.message(
      'إرسال الى ',
      name: 'send_to',
      desc: '',
      args: [],
    );
  }

  /// `واتساب`
  String get whatsapp {
    return Intl.message(
      'واتساب',
      name: 'whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `التطبيق`
  String get app {
    return Intl.message(
      'التطبيق',
      name: 'app',
      desc: '',
      args: [],
    );
  }

  /// `عنوان الإستلام`
  String get deliver_address {
    return Intl.message(
      'عنوان الإستلام',
      name: 'deliver_address',
      desc: '',
      args: [],
    );
  }

  /// `مشاهدة الكل`
  String get see_all {
    return Intl.message(
      'مشاهدة الكل',
      name: 'see_all',
      desc: '',
      args: [],
    );
  }

  /// `تفاصيل الطلب`
  String get product_details {
    return Intl.message(
      'تفاصيل الطلب',
      name: 'product_details',
      desc: '',
      args: [],
    );
  }

  /// `تاريخ الطلب`
  String get order_date {
    return Intl.message(
      'تاريخ الطلب',
      name: 'order_date',
      desc: '',
      args: [],
    );
  }

  /// `تفاصيل الطلب`
  String get order_details {
    return Intl.message(
      'تفاصيل الطلب',
      name: 'order_details',
      desc: '',
      args: [],
    );
  }

  /// `التفاصيل`
  String get details {
    return Intl.message(
      'التفاصيل',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `منتجات ذات صلة`
  String get related_products {
    return Intl.message(
      'منتجات ذات صلة',
      name: 'related_products',
      desc: '',
      args: [],
    );
  }

  /// `العربية`
  String get arabic {
    return Intl.message(
      'العربية',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `الإنكليزية`
  String get english {
    return Intl.message(
      'الإنكليزية',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `التركية`
  String get turkish {
    return Intl.message(
      'التركية',
      name: 'turkish',
      desc: '',
      args: [],
    );
  }

  /// `عند تسجيل الدخول ستتمكن من الإستفادة من مزايا التطبيق ومشاهدة العروض الخاصة للمستخدمين.`
  String get by_login_dialoge {
    return Intl.message(
      'عند تسجيل الدخول ستتمكن من الإستفادة من مزايا التطبيق ومشاهدة العروض الخاصة للمستخدمين.',
      name: 'by_login_dialoge',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد مفضلة`
  String get no_favorite {
    return Intl.message(
      'لا يوجد مفضلة',
      name: 'no_favorite',
      desc: '',
      args: [],
    );
  }

  /// `يمكنك إضافة عنوانك مباشرةً لإستخدامة في عملية الشراء بسهولة.`
  String get add_address_subtitle {
    return Intl.message(
      'يمكنك إضافة عنوانك مباشرةً لإستخدامة في عملية الشراء بسهولة.',
      name: 'add_address_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `سيتم إظهار الإشعارات الخاصة بك بمجرد حصول أي حدث جديد.`
  String get no_notifications_subtitle {
    return Intl.message(
      'سيتم إظهار الإشعارات الخاصة بك بمجرد حصول أي حدث جديد.',
      name: 'no_notifications_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `سيتم إظهار المنتجات هنا عند توفرها مباشرةً.`
  String get no_result_subtitle {
    return Intl.message(
      'سيتم إظهار المنتجات هنا عند توفرها مباشرةً.',
      name: 'no_result_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `يمكنك تجربة البحث بكلمات مختلفة عن المنتجات التي تبحث عنها.`
  String get no_search_subtitle {
    return Intl.message(
      'يمكنك تجربة البحث بكلمات مختلفة عن المنتجات التي تبحث عنها.',
      name: 'no_search_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `يمكنك رؤية جميع المنتجات المفضلة لديك هنا من مكان واحد.`
  String get no_favorite_subtitle {
    return Intl.message(
      'يمكنك رؤية جميع المنتجات المفضلة لديك هنا من مكان واحد.',
      name: 'no_favorite_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `الصفحة الرئيسية`
  String get home_title_tour {
    return Intl.message(
      'الصفحة الرئيسية',
      name: 'home_title_tour',
      desc: '',
      args: [],
    );
  }

  /// `هنا تجد المنتجات المميزة و أحدث العروض.`
  String get home_subtitle_tour {
    return Intl.message(
      'هنا تجد المنتجات المميزة و أحدث العروض.',
      name: 'home_subtitle_tour',
      desc: '',
      args: [],
    );
  }

  /// `من هنا يمكنك الدخول إلى التصنيفات الرئيسية.`
  String get categories_tour {
    return Intl.message(
      'من هنا يمكنك الدخول إلى التصنيفات الرئيسية.',
      name: 'categories_tour',
      desc: '',
      args: [],
    );
  }

  /// `هنا تجد المنتجات التي تمت إضافتها للسلة لمتابعة عملية الشراء.`
  String get cart_tour {
    return Intl.message(
      'هنا تجد المنتجات التي تمت إضافتها للسلة لمتابعة عملية الشراء.',
      name: 'cart_tour',
      desc: '',
      args: [],
    );
  }

  /// `هنا تجد المنتجات التي قمت بإضافتها للمفضلة.`
  String get favorite_tour {
    return Intl.message(
      'هنا تجد المنتجات التي قمت بإضافتها للمفضلة.',
      name: 'favorite_tour',
      desc: '',
      args: [],
    );
  }

  /// `حيث تجد المعلومات الشخصية و الطلبات السابقة لديك.`
  String get profile_tour {
    return Intl.message(
      'حيث تجد المعلومات الشخصية و الطلبات السابقة لديك.',
      name: 'profile_tour',
      desc: '',
      args: [],
    );
  }

  /// `للبحث عن أي منتج مع إمكانية الفلترة حسب (السعر,التصنيف,التقييم..).`
  String get search_tour {
    return Intl.message(
      'للبحث عن أي منتج مع إمكانية الفلترة حسب (السعر,التصنيف,التقييم..).',
      name: 'search_tour',
      desc: '',
      args: [],
    );
  }

  /// `لحذف المنتج من السلة, قم بسحب المنتج  `
  String get delete_tour {
    return Intl.message(
      'لحذف المنتج من السلة, قم بسحب المنتج  ',
      name: 'delete_tour',
      desc: '',
      args: [],
    );
  }

  /// `لمتابعة عملية الشراء عن طريق التطبيق وباستخدام معلومات الحساب الشخصي (يتطلب تسجيل دخول)`
  String get checkout_tour {
    return Intl.message(
      'لمتابعة عملية الشراء عن طريق التطبيق وباستخدام معلومات الحساب الشخصي (يتطلب تسجيل دخول)',
      name: 'checkout_tour',
      desc: '',
      args: [],
    );
  }

  /// `شراء السلة عن طريق الواتساب`
  String get checkout_whatsapp_tour_title {
    return Intl.message(
      'شراء السلة عن طريق الواتساب',
      name: 'checkout_whatsapp_tour_title',
      desc: '',
      args: [],
    );
  }

  /// ` عن طريق ارسال رسالة واتساب للبائع تحوي معلومات السلة دون الحاجة لتسجيل الدخول`
  String get checkout_whatsapp_tour_subtitle {
    return Intl.message(
      ' عن طريق ارسال رسالة واتساب للبائع تحوي معلومات السلة دون الحاجة لتسجيل الدخول',
      name: 'checkout_whatsapp_tour_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `لتعديل المعلومات الشخصية اضغط هنا.`
  String get edit_profile_tour {
    return Intl.message(
      'لتعديل المعلومات الشخصية اضغط هنا.',
      name: 'edit_profile_tour',
      desc: '',
      args: [],
    );
  }

  /// `هنا يمكنك إضافة و تعديل عناوينك الخاصة.`
  String get address_tour {
    return Intl.message(
      'هنا يمكنك إضافة و تعديل عناوينك الخاصة.',
      name: 'address_tour',
      desc: '',
      args: [],
    );
  }

  /// `هنا يمكنك تتبع حالة الطلبات الخاصة بك .`
  String get order_tour {
    return Intl.message(
      'هنا يمكنك تتبع حالة الطلبات الخاصة بك .',
      name: 'order_tour',
      desc: '',
      args: [],
    );
  }

  /// `خيارات`
  String get options {
    return Intl.message(
      'خيارات',
      name: 'options',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء تحديد خيارات المنتج قبل إضافته للسلة.`
  String get selectOptions {
    return Intl.message(
      'الرجاء تحديد خيارات المنتج قبل إضافته للسلة.',
      name: 'selectOptions',
      desc: '',
      args: [],
    );
  }

  /// `تطبيق`
  String get use_coupon {
    return Intl.message(
      'تطبيق',
      name: 'use_coupon',
      desc: '',
      args: [],
    );
  }

  /// `كوبون`
  String get coupon {
    return Intl.message(
      'كوبون',
      name: 'coupon',
      desc: '',
      args: [],
    );
  }

  /// `تم إستخدام الكوبون.`
  String get coupon_accepted {
    return Intl.message(
      'تم إستخدام الكوبون.',
      name: 'coupon_accepted',
      desc: '',
      args: [],
    );
  }

  /// `الكوبون غير صالح.`
  String get coupon_rejected {
    return Intl.message(
      'الكوبون غير صالح.',
      name: 'coupon_rejected',
      desc: '',
      args: [],
    );
  }

  /// `نقاطي`
  String get my_points {
    return Intl.message(
      'نقاطي',
      name: 'my_points',
      desc: '',
      args: [],
    );
  }

  /// `نقاط كارنيد `
  String get carneed_points {
    return Intl.message(
      'نقاط كارنيد',
      name: 'carneed_points',
      desc: '',
      args: [],
    );
  }

  /// `تستخدم في تخفيض التكلفة على مشترياتك, حيث يمكنك استبدالهم بمنتجات معينة.`
  String get carneed_points_desc {
    return Intl.message(
      'تستخدم في تخفيض التكلفة على مشترياتك, حيث يمكنك استبدالهم بمنتجات معينة.',
      name: 'carneed_points_desc',
      desc: '',
      args: [],
    );
  }

  /// `رصيد النقاط الحالي`
  String get current_points_balance {
    return Intl.message(
      'رصيد النقاط الحالي',
      name: 'current_points_balance',
      desc: '',
      args: [],
    );
  }

  /// `النقاط المستخدمة`
  String get used_points {
    return Intl.message(
      'النقاط المستخدمة',
      name: 'used_points',
      desc: '',
      args: [],
    );
  }

  /// `كمية التوفير من إستخدام النقاط`
  String get total_saving {
    return Intl.message(
      'كمية التوفير من إستخدام النقاط',
      name: 'total_saving',
      desc: '',
      args: [],
    );
  }

  /// `نقطة`
  String get point {
    return Intl.message(
      'نقطة',
      name: 'point',
      desc: '',
      args: [],
    );
  }

  /// `إستبدال النقاط`
  String get change_points_with_products {
    return Intl.message(
      'إستبدال النقاط',
      name: 'change_points_with_products',
      desc: '',
      args: [],
    );
  }

  /// `اشتري الأن`
  String get buyNow {
    return Intl.message(
      'اشتري الأن',
      name: 'buyNow',
      desc: '',
      args: [],
    );
  }

  /// `شارك التطبيق مع أصدقائك لتحصل على المزيد من النقاط`
  String get share_to_get_points {
    return Intl.message(
      'شارك التطبيق مع أصدقائك لتحصل على المزيد من النقاط',
      name: 'share_to_get_points',
      desc: '',
      args: [],
    );
  }

  /// `ليس لديك نقاط كافية`
  String get dont_have_points_enogh {
    return Intl.message(
      'ليس لديك نقاط كافية',
      name: 'dont_have_points_enogh',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
