import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


Column EmptyList() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: SvgPicture.asset(
              'assets/images/empty_likes.svg',
              width: 150,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              "vous n'avez encore pas liké de contenu",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Cliquez sur le coeur pour en rajouter",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ],
      ),
    ],
  );
}
