// ignore_for_file: file_names

import 'package:flutter/widgets.dart';

/// Recreates a touchable opacity from React Native.
///  On tap down, the opacity of the
/// child is decreased, dimming it.
/// Use this in place of a Container and it will include
/// tap events.
///
/// [child] (required) is what will be displayed within the
/// touchable highlight on top of the background color.
/// [onTap] is the callback which will execute when tapped.
/// [onLongPress] callback executed on long press event.
/// [width] width supplied to the enclosing container.
/// [height] height supplied to the enclosing container
/// [decoration] decoration supplied to the enclosing container.
class TouchableOpacity extends StatefulWidget {
  const TouchableOpacity({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.decoration,
    this.width,
    this.height,
    super.key,
    this.behavior = HitTestBehavior.opaque,
    this.disabled = false,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });
  final Widget child;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BoxDecoration? decoration;
  final HitTestBehavior behavior;
  final bool disabled;
  final Function? onTapDown;
  final Function? onTapUp;
  final Function? onTapCancel;

  @override
  State<TouchableOpacity> createState() => _TouchableOpacity();
}

class _TouchableOpacity extends State<TouchableOpacity> {
  bool isTappedDown = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        behavior: widget.behavior,
        onTapDown: (tapDownDetails) {
          if (widget.disabled) {
            return;
          }

          setState(() {
            isTappedDown = true;
          });

          if (widget.onTapDown != null) {
            // ignore: avoid_dynamic_calls
            widget.onTapDown?.call();
          }
        },
        onTapUp: (tapUpDetails) {
          setState(() {
            isTappedDown = false;
          });

          if (widget.onTapUp != null) {
            // ignore: avoid_dynamic_calls
            widget.onTapUp?.call();
          }
        },
        onTapCancel: () {
          setState(() {
            isTappedDown = false;
          });

          if (widget.onTapCancel != null) {
            // ignore: avoid_dynamic_calls
            widget.onTapCancel?.call();
          }
        },
        onTap: widget.disabled ? null : widget.onTap,
        onLongPress: widget.disabled ? null : widget.onLongPress,
        child: Opacity(
          opacity: isTappedDown ? 0.6 : 1.0,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: widget.decoration,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}