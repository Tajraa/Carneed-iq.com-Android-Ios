import 'package:flutter/material.dart';
import 'package:progiom_cms/auth.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:tajra/App/Widgets/LoginDialoge.dart';
import 'package:tajra/generated/l10n.dart';
import '/Utils/SizeConfig.dart';

import '../../../injections.dart';

class FavoriteButton extends StatefulWidget {
  FavoriteButton({required this.isFavorite, required this.id, Key? key})
      : super(key: key);
  final bool isFavorite;
  final int id;
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState(isFavorite);
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite;
  _FavoriteButtonState(this.isFavorite);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (sl<AuthBloc>().isGuest) {
            showLoginDialoge(context);
          } else {
            setState(() {
              isFavorite = !isFavorite;
            });
            setIsFavorite();
            
          }
        },
        child: Container(
          padding: EdgeInsets.all(SizeConfig.h(2)),
          child: Center(
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: SizeConfig.h(18),
              color: isFavorite ? Colors.red : null,
            ),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          height: SizeConfig.h(24),
          width: SizeConfig.h(24),
        ));
  }

  final debouncer = Debouncer(milliseconds: 500);
  void setIsFavorite() {
    debouncer.run(() {
      SetIsFavorite(sl()).call(SetIsFavoriteParams(
          isFavorite: isFavorite, itemId: widget.id.toString()));
    });
  }
}
