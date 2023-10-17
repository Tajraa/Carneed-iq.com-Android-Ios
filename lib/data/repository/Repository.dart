import 'package:flutter/services.dart';

import 'package:progiom_cms/auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progiom_cms/core.dart';
import 'package:dartz/dartz.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '/data/httpService/http_Service.dart';
import '/data/sharedPreferences/SharedPrefHelper.dart';

import '../../../injections.dart';

class Repository {
  final HttpSerivce apiHelper;
  final PrefsHelper prefsHelper;
  Repository(this.prefsHelper, this.apiHelper);

  uploadFile(
    String path,
  ) async {
    return await apiHelper.uploadFile(
      path,
    );
  }

  Future<Either<Failure, String>> getFacebookToken() async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ['public_profile', 'email']);

      if (result.status == LoginStatus.success) {
        return Right(result.accessToken?.token ?? "");
      } else if (result.status == LoginStatus.cancelled) {
        return Left(ServerFailure("User Canceled!"));
      } else if (result.status == LoginStatus.failed) {
        return Left(ServerFailure(result.message ?? ""));
      }
      return Left(ServerFailure("Unknown Error!"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future setFcmToken() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      await FirebaseMessaging.instance.getToken().then((value) {
        if (value != null)
          SetFcmToken(sl()).call(SetFcmTokenParams(token: value));
      }).catchError((onError) {});
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      await FirebaseMessaging.instance.getToken().then((value) {
        if (value != null)
          SetFcmToken(sl()).call(SetFcmTokenParams(token: value));
      }).catchError((onError) {});
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<Either<Failure, String>> logInByApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'demo1.tajraa.com',
          redirectUri: Uri.parse(
            'https://demo1.tajraa.com/login/apple/callback',
          ),
        ),
      );

      print(credential);
      return Right(credential.authorizationCode);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> getGoogleToken() async {
    try {
      var googleSignIn = GoogleSignIn(
        scopes: [
          "email",
          "profile",
        ],
        hostedDomain: "",
      );
      GoogleSignInAccount? googleSignInAccount;

      if (googleSignInAccount == null) {
        //not sign in previsly
        var error;
        googleSignInAccount = await googleSignIn.signIn().catchError((onError) {
          error = onError.toString();
        });
        print(googleSignInAccount ?? "error in google $error");
        if (error != null) return Left(ServerFailure(error));
      }
      if (googleSignInAccount != null) {
        //process success

        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final token = googleSignInAuthentication;
        return Right(token.accessToken!);
        // return {
        //   "googleId": googleSignInAccount.id,
        //   "email": googleSignInAccount.email,
        //   "googleAccessToken": token.accessToken,
        //   "name": googleSignInAccount.displayName,
        //   "photo": googleSignInAccount.photoUrl
        // };
      }
      return Left(ServerFailure("Unknown error"));
    } on PlatformException catch (e) {
      print(e.toString());
      return Left(ServerFailure("Unknown error"));
    } catch (e) {
      print(e.toString());
      return Left(ServerFailure("Unknown error"));
    }
  }
}
