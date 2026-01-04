import 'package:flutter/material.dart';

extension ImageExtensions on Image {
  Image resorceImageByName(String name) {
    return Image.asset("assets/images/$name");
  }
}
