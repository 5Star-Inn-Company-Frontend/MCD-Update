import 'package:flutter/material.dart';

class CustomMarquee extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double velocity;
  final Duration pauseDuration;

  const CustomMarquee({
    Key? key,
    required this.text,
    this.style,
    this.velocity = 50.0,
    this.pauseDuration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  State<CustomMarquee> createState() => _CustomMarqueeState();
}

class _CustomMarqueeState extends State<CustomMarquee>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<Offset>? _animation;
  double _textWidth = 0;
  double _containerWidth = 0;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    
    // Initialize with a default animation
    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0),
    ).animate(_controller);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAnimation();
    });
  }

  void _initializeAnimation() {
    final RenderBox? textBox =
        _textKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? containerBox = context.findRenderObject() as RenderBox?;

    if (textBox != null && containerBox != null) {
      setState(() {
        _textWidth = textBox.size.width;
        _containerWidth = containerBox.size.width;
      });

      if (_textWidth > _containerWidth) {
        final double distance = _textWidth + _containerWidth;
        final Duration duration = Duration(
          milliseconds: ((distance / widget.velocity) * 1000).round(),
        );

        _controller.duration = duration;
        _animation = Tween<Offset>(
          begin: const Offset(0, 0),
          end: Offset(-1, 0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));

        _controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Future.delayed(widget.pauseDuration, () {
              if (mounted) {
                _controller.reset();
                _controller.forward();
              }
            });
          }
        });

        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final animation = _animation;
          if (animation == null) {
            return Text(
              widget.text,
              key: _textKey,
              style: widget.style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }
          
          return Transform.translate(
            offset: Offset(
              animation.value.dx * (_textWidth + _containerWidth),
              0,
            ),
            child: Row(
              children: [
                Text(
                  widget.text,
                  key: _textKey,
                  style: widget.style,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  softWrap: false,
                ),
                if (_textWidth > _containerWidth) ...[
                  SizedBox(width: _containerWidth * 0.5),
                  Text(
                    widget.text,
                    style: widget.style,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
