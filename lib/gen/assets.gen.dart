/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/apple.svg
  String get apple => 'assets/icons/apple.svg';

  /// File path: assets/icons/clock.svg
  String get clock => 'assets/icons/clock.svg';

  /// File path: assets/icons/copy.svg
  String get copy => 'assets/icons/copy.svg';

  /// File path: assets/icons/delete.svg
  String get delete => 'assets/icons/delete.svg';

  /// File path: assets/icons/file.svg
  String get file => 'assets/icons/file.svg';

  /// File path: assets/icons/google.svg
  String get google => 'assets/icons/google.svg';

  /// File path: assets/icons/home.svg
  String get home => 'assets/icons/home.svg';

  /// File path: assets/icons/home_filled.svg
  String get homeFilled => 'assets/icons/home_filled.svg';

  /// File path: assets/icons/logo.svg
  String get logo => 'assets/icons/logo.svg';

  /// File path: assets/icons/no-image.svg
  String get noImage => 'assets/icons/no-image.svg';

  /// File path: assets/icons/profile.svg
  String get profile => 'assets/icons/profile.svg';

  /// File path: assets/icons/profile_filled.svg
  String get profileFilled => 'assets/icons/profile_filled.svg';

  /// File path: assets/icons/text.svg
  String get text => 'assets/icons/text.svg';

  /// File path: assets/icons/update.svg
  String get update => 'assets/icons/update.svg';

  /// File path: assets/icons/url.svg
  String get url => 'assets/icons/url.svg';

  /// List of all assets
  List<String> get values => [
        apple,
        clock,
        copy,
        delete,
        file,
        google,
        home,
        homeFilled,
        logo,
        noImage,
        profile,
        profileFilled,
        text,
        update,
        url
      ];
}

class $AssetsOnboardingGen {
  const $AssetsOnboardingGen();

  /// File path: assets/onboarding/onboardingBG.png
  AssetGenImage get onboardingBG =>
      const AssetGenImage('assets/onboarding/onboardingBG.png');

  /// File path: assets/onboarding/onboardingImg1.png
  AssetGenImage get onboardingImg1 =>
      const AssetGenImage('assets/onboarding/onboardingImg1.png');

  /// File path: assets/onboarding/onboardingImg2.png
  AssetGenImage get onboardingImg2 =>
      const AssetGenImage('assets/onboarding/onboardingImg2.png');

  /// File path: assets/onboarding/onboardingImg3.png
  AssetGenImage get onboardingImg3 =>
      const AssetGenImage('assets/onboarding/onboardingImg3.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [onboardingBG, onboardingImg1, onboardingImg2, onboardingImg3];
}

class Assets {
  Assets._();

  static const AssetGenImage bg = AssetGenImage('assets/BG.png');
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsOnboardingGen onboarding = $AssetsOnboardingGen();
  static const AssetGenImage placeholderLogo =
      AssetGenImage('assets/placeholder_logo.png');

  /// List of all assets
  static List<AssetGenImage> get values => [bg, placeholderLogo];
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
