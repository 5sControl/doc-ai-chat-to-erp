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
    final imageUrl = summaryData.summaryPreview.imageUrl;
    final bool isValidUrl = imageUrl != null && 
                           imageUrl.isNotEmpty && 
                           imageUrl != Assets.placeholderLogo.path;
    final bool isNetworkImage = isValidUrl && 
                               (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final bool isAssetImage = isValidUrl && imageUrl.startsWith('assets/');
    
    return Hero(
      tag: summaryData.date,
      child: ClipRRect(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: 15, sigmaY: 15, tileMode: TileMode.mirror),
          child: isNetworkImage
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  color: Colors.black54,
                  colorBlendMode: BlendMode.colorBurn,
                )
              : Image.asset(
                  isAssetImage ? imageUrl : Assets.placeholderLogo.path,
                  fit: BoxFit.cover,
                  color: Colors.black54,
                  colorBlendMode: BlendMode.colorBurn,
                ),
        ),
      ),
    );
  }
}