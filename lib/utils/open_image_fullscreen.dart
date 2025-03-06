import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

void openImage(context, image) async {
  final imageProvider = Image.memory(image).image;
  await showImageViewer(context, imageProvider);
}
