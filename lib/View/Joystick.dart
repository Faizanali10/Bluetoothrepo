import 'dart:math';

import 'package:flutter/material.dart';

class JoyStick extends StatefulWidget {
  const JoyStick({super.key});

  @override
  State<JoyStick> createState() => _JoyStickState();
}

class _JoyStickState extends State<JoyStick> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Center(child: Text('JoyStick')),
      ),
      body:Center(
        child:
        JoystickCircle(),

        // Joystick(
        //   // opacity: 0,
        //   iconColor: Colors.black,
        //   backgroundColor: Colors.white,
        //   isDraggable: true,
        //   size: 300,
        //   joystickMode: JoystickModes.all,
        // ),
      )

      // const Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     // CircleWithBorder(
      //     //   size: 200,
      //     //   borderWidth: 5,
      //     //   borderColor: Colors.red,
      //     // ),
      //     Center(
      //       child: CircleWithBorderAndShadow(
      //         size: 300,
      //         borderWidth: 1,
      //         borderColor: Colors.black,
      //         shadowColor: Colors.grey,
      //         shadowBlurRadius: 5,
      //         insideColor: Colors.white,
      //         shadowOffset: Offset(-1, -1),
      //       ),
      //     ),
      //   ],
      // ),
    )
    );
  }
}





class CircleWithBorderAndShadow extends StatelessWidget {
  final double size;
  final double borderWidth;
  final Color borderColor;
  final Color shadowColor;
  final Color insideColor;
  final double shadowBlurRadius;
  final Offset shadowOffset;

  const CircleWithBorderAndShadow({super.key,
    required this.size,
    required this.borderWidth,
    required this.borderColor,
    required this.shadowColor,
    required this.insideColor,
    required this.shadowBlurRadius,
    required this.shadowOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(width: borderWidth, color: borderColor),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: shadowBlurRadius,
            offset: shadowOffset,
          ),
        ],

      ),
  child:const Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Icon(Icons.arrow_drop_up,size: 80,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.arrow_left,size: 80,),
          Center(
            child: FilledCircle(size: 100,fillColor: Colors.black,)
          ),

          Icon(Icons.arrow_right,size: 80,),

        ],
      ),
      Icon(Icons.arrow_drop_down,size: 80,),

    ],
  ),
    );

  }
}

// Usage example:
// CircleWithBorderAndShadow(
//   size: 100,
//   borderWidth: 5,
//   borderColor: Colors.red,
//   shadowColor: Colors.grey,
//   shadowBlurRadius: 5,
//   shadowOffset: Offset(0, 2),
// ),

// Usage example:

class FilledCircle extends StatelessWidget {
  final double size;
  final Color fillColor;

  const FilledCircle({super.key, required this.size, required this.fillColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
      ),
    );
  }
}

class DraggableCircle extends StatefulWidget {
  final double size;
  final Color color;

  const DraggableCircle({super.key, required this.size, required this.color});

  @override
  _DraggableCircleState createState() => _DraggableCircleState();
}

class _DraggableCircleState extends State<DraggableCircle> {
  Offset position = const Offset(0, 0);

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      position = Offset(
        position.dx + details.delta.dx,
        position.dy + details.delta.dy,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}












































enum Directions { up, down, right, left }

enum JoystickModes { all, horizontal, vertical }

class Joystick extends StatefulWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  final double? opacity;
  final double size;
  final bool? isDraggable;
  final JoystickModes? joystickMode;
  // callbacks
  final VoidCallback? onUpPressed;
  final VoidCallback? onDownPressed;
  final VoidCallback? onRightPressed;
  final VoidCallback? onLeftPressed;
  final Function(Directions)? onPressed;
  //
  Joystick(
      {this.backgroundColor,
        this.iconColor,
        this.opacity,
        this.isDraggable,
        required this.size,
        this.joystickMode,
        this.onUpPressed,
        this.onDownPressed,
        this.onLeftPressed,
        this.onRightPressed,
        this.onPressed})
      : assert(isDraggable != null);
  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  double _x = 0;
  double _y = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Positioned(
                bottom: _y,
                right: _x,
                child: GestureDetector(
                  onLongPress: (widget.isDraggable == false)
                      ? null
                      : () {
                    setState(() {
                      _x = 0;
                      _y = 0;
                    });
                  },
                  child: Container(
                    height: widget.size,
                    width: widget.size,
                    decoration: BoxDecoration(
                        color: widget.backgroundColor
                            ?.withOpacity(widget.opacity ?? 1) ??
                            Colors.black.withOpacity(widget.opacity ?? 1),
                        shape: BoxShape.circle),
                    child: Column(children: [
                      // up
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(),
                            ),
                            Expanded(
                              child: (widget.joystickMode == JoystickModes.horizontal)
                                  ? SizedBox()
                                  : IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  size:80,
                                    Icons.arrow_drop_up,
                                  color: widget.iconColor ?? Colors.black,),
                                onPressed: () {
                                  if (widget.onUpPressed != null)
                                    widget.onUpPressed!();
                                  if (widget.onPressed != null)
                                    widget.onPressed!(Directions.up);
                                },
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            )
                          ],
                        ),
                      ),
                      // middle
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: (widget.joystickMode == JoystickModes.vertical)
                                  ? SizedBox()
                                  : IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  size:80,
                                  Icons.arrow_left,
                                  color: widget.iconColor ?? Colors.black,
                                ),
                                onPressed: () {
                                  if (widget.onLeftPressed != null)
                                    widget.onLeftPressed!();
                                  if (widget.onPressed != null)
                                    widget.onPressed!(Directions.left);
                                },
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                child:
                                // Icon(
                                //   Icons.drag_handle,
                                //   color: widget.iconColor ?? Colors.black,
                                // ),
                                FilledCircle(size: 100,fillColor: Colors.black,),
                                onPanUpdate: (_values) {
                                  if (widget.isDraggable == true) {
                                    setState(() {
                                      _x -= _values.delta.dx;
                                      _y -= _values.delta.dy;
                                    });
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: (widget.joystickMode == JoystickModes.vertical)
                                  ? SizedBox()
                                  : IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  size:80,
                                  Icons.arrow_right,
                                  color: widget.iconColor ?? Colors.black,
                                ),
                                onPressed: () {
                                  if (widget.onRightPressed != null)
                                    widget.onRightPressed!();
                                  if (widget.onPressed != null)
                                    widget.onPressed!(Directions.right);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      // down
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(),
                            ),
                            Expanded(
                              child: (widget.joystickMode == JoystickModes.horizontal)
                                  ? SizedBox()
                                  : IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  size:80,
                                  Icons.arrow_drop_down,
                                  color: widget.iconColor ?? Colors.black,
                                ),
                                onPressed: () {
                                  if (widget.onDownPressed != null)
                                    widget.onDownPressed!();
                                  if (widget.onPressed != null)
                                    widget.onPressed!(Directions.down);
                                },
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}







class JoystickCircle extends StatefulWidget {
  @override
  _JoystickCircleState createState() => _JoystickCircleState();
}

class _JoystickCircleState extends State<JoystickCircle> {
  Offset _circlePosition = Offset(0, 0);
  double _joystickRadius = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Container(
            width: _joystickRadius * 6,
            height: _joystickRadius * 6,
            decoration: BoxDecoration(
              border: Border.all(width: 1,),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 2,
                  blurRadius: 1,
                  offset: Offset(0,1)
                )
              ],
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Icon(
                    size:80,
                    Icons.arrow_drop_up,
                    color:  Colors.black,),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        size:80,
                        Icons.arrow_left,
                        color:  Colors.black,),
                      Center(
                        child: Transform.translate(
                          offset: _circlePosition,
                          child: Container(
                            width: _joystickRadius*2,
                            height: _joystickRadius*2,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(_joystickRadius /0.005),
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        size:80,
                        Icons.arrow_right,
                        color:  Colors.black,),
                    ],
                  ),
                ),
                Center(
                  child: Icon(
                    size:80,
                    Icons.arrow_drop_down,
                    color:  Colors.black,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _updateCirclePosition(details.localPosition);

    print('on panStart ${details.localPosition}');
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updateCirclePosition(details.localPosition);
    print('on panUpdate ${details.localPosition}');
  }

  void _onPanEnd(DragEndDetails details) {
    // Reset the circle position when the user lifts their finger
    _updateCirclePosition(Offset(0, 0));
    print('on panEnd');
  }

  // void _updateCirclePosition(Offset position) {
  //   // Calculate the distance from the center of the joystick to the touch point
  //   double distance = position.distance;
  //
  //   // Limit the movement within the joystick radius
  //   if (distance <= _joystickRadius) {
  //     setState(() {
  //       _circlePosition = position;
  //     });
  //   } else {
  //     // Calculate the normalized direction vector
  //     Offset direction = position - Offset(0, 0);
  //     direction = direction / distance;
  //
  //     // Set the circle position at the edge of the joystick
  //     setState(() {
  //       _circlePosition = direction * _joystickRadius;
  //     });
  //   }
  //   print('on update circle position');
  // }
  void _updateCirclePosition(Offset position) {
    // Calculate the distance from the center of the joystick to the touch point
    double distance = position.distance;

    // Limit the movement within the joystick radius
    if (distance <= _joystickRadius) {
      setState(() {
        _circlePosition = position;
      });
    } else {
      // Calculate the normalized direction vector
      Offset direction = position - Offset(0, 0);
      direction = direction / distance;

      // Calculate the new position relative to the current circle position
      double newX = direction.dx * _joystickRadius;
      double newY = direction.dy * _joystickRadius;

      setState(() {
        _circlePosition = Offset(newX, newY);
      });
    }}
}
