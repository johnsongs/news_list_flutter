import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @Description TODO
/// @Author Johnson
/// @Date 2022/6/11 5:37 下午
extension WidgetExt on Widget {
  GestureDetector setTouchEvent(
      {Key? key, Function? onTap, Function? onTapUp, Function? onTapDown}) {
    return GestureDetector(
      key: key,
      behavior: HitTestBehavior.opaque,
      child: this,
      onTap: () => onTap?.call(),
      onTapUp: (_) => onTapUp?.call(),
      onTapDown: (_) => onTapDown?.call(),
    );
  }

  Container withSize({
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
  }) {
    return Container(
        key: key,
        alignment: alignment,
        padding: padding,
        color: color,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        child: this);
  }

  Padding setPadding(EdgeInsets edgeInsets, {Key? key}) {
    return Padding(
      key: key,
      child: this,
      padding: edgeInsets,
    );
  }

  Expanded setFlex({Key? key, int flex = 1}) {
    return Expanded(key: key, flex: flex, child: this);
  }
}
