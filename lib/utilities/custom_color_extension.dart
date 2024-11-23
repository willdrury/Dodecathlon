import 'package:flutter/material.dart';

class CustomColorsExtension extends ThemeExtension<CustomColorsExtension> {
  CustomColorsExtension({
    required this.primaryDim,
  });

  final Color primaryDim;

  @override
  ThemeExtension<CustomColorsExtension> copyWith({
    Color? primaryDim,
  }) {
    return CustomColorsExtension(
      primaryDim: primaryDim ?? this.primaryDim,
    );
  }

  @override
  ThemeExtension<CustomColorsExtension> lerp(
      covariant ThemeExtension<CustomColorsExtension>? other,
      double t,
      ) {
    if (other is! CustomColorsExtension) {
      return this;
    }

    return CustomColorsExtension(
      primaryDim: Color.lerp(primaryDim, other.primaryDim, t)!,
    );
  }
}