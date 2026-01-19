// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// Directory path: assets/fonts/inter
  $AssetsFontsInterGen get inter => const $AssetsFontsInterGen();
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/svg
  $AssetsImagesSvgGen get svg => const $AssetsImagesSvgGen();
}

class $AssetsFontsInterGen {
  const $AssetsFontsInterGen();

  /// File path: assets/fonts/inter/Inter-Italic-Variable.ttf
  String get interItalicVariable =>
      'assets/fonts/inter/Inter-Italic-Variable.ttf';

  /// File path: assets/fonts/inter/Inter-Variable.ttf
  String get interVariable => 'assets/fonts/inter/Inter-Variable.ttf';

  /// List of all assets
  List<String> get values => [interItalicVariable, interVariable];
}

class $AssetsImagesSvgGen {
  const $AssetsImagesSvgGen();

  /// File path: assets/images/svg/apple.svg
  String get apple => 'assets/images/svg/apple.svg';

  /// Directory path: assets/images/svg/empty
  $AssetsImagesSvgEmptyGen get empty => const $AssetsImagesSvgEmptyGen();

  /// File path: assets/images/svg/google.svg
  String get google => 'assets/images/svg/google.svg';

  /// File path: assets/images/svg/ic_error.svg
  String get icError => 'assets/images/svg/ic_error.svg';

  /// File path: assets/images/svg/success_sign.svg
  String get successSign => 'assets/images/svg/success_sign.svg';

  /// List of all assets
  List<String> get values => [apple, google, icError, successSign];
}

class $AssetsImagesSvgEmptyGen {
  const $AssetsImagesSvgEmptyGen();

  /// File path: assets/images/svg/empty/no_data.svg
  String get noData => 'assets/images/svg/empty/no_data.svg';

  /// File path: assets/images/svg/empty/no_search_result.svg
  String get noSearchResult => 'assets/images/svg/empty/no_search_result.svg';

  /// List of all assets
  List<String> get values => [noData, noSearchResult];
}

class Assets {
  const Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}
