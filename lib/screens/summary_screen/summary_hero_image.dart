import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:summify/models/models.dart';

import '../../gen/assets.gen.dart';

class SummaryHeroImage extends StatelessWidget {
  final SummaryData summaryData;
  const SummaryHeroImage({super.key, required this.summaryData});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: summaryData.date,
      child: ClipRRect(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: 15, sigmaY: 15, tileMode: TileMode.mirror),
          child:
          summaryData.summaryPreview.imageUrl != Assets.placeholderLogo.path
              ? CachedNetworkImage(
            imageUrl: summaryData.summaryPreview.imageUrl ?? '',
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.colorBurn,
          )
              : Image.asset(
            Assets.placeholderLogo.path,
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.colorBurn,
          ),
        ),
      ),
    );
  }
}