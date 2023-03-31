import 'package:flutter/material.dart';

class BtnUI extends StatefulWidget {
  const BtnUI(
      {this.fieldKey,
      this.color,
      this.textColor,
      this.text,
      this.onTap,
      this.height = 50,
      this.width,
      this.padding,
      this.isLoading,
      this.child,
      this.align});

  final Key fieldKey;
  final String text;
  final Color color;
  final Color textColor;
  final double height;
  final double width;
  final EdgeInsets padding;
  final child;
  final bool isLoading;
  final Alignment align;
  final GestureTapCallback onTap;

  @override
  _BtnUIState createState() => _BtnUIState();
}

class _BtnUIState extends State<BtnUI> with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  @override
  initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: widget.padding,
          constraints: BoxConstraints(maxWidth: 450),
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(27.0),
              boxShadow: [
                BoxShadow(
                    color: Color(0xAA325ED).withAlpha(20),
                    offset: Offset(0, 24),
                    blurRadius: 48,
                    spreadRadius: -18)
              ]),
          child: Stack(
            children: [
              widget.isLoading == false
                  ? Padding(
                      padding: widget.align != null
                          ? const EdgeInsets.only(left: 20)
                          : const EdgeInsets.all(1),
                      child: Align(
                        alignment: widget.align != null
                            ? widget.align
                            : Alignment.center,
                        child: Text(
                          widget.text,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              widget.isLoading == true
                  ? Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
