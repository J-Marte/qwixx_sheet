/*
  MIT License

  Copyright (c) [2022] [Johannes Marte]

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
*/

import 'package:flutter/material.dart';

class NumberTick extends StatelessWidget {
  const NumberTick({Key? key, required this.color, this.number = 1, this.size, this.backgroundColor = Colors.white, required this.value, this.onClick, this.enabled = true}) : super(key: key);

  final Color color;
  final Color backgroundColor;
  final int number;
  final double? size;
  final bool value;
  final bool enabled;
  final void Function(bool)? onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if (enabled && onClick != null){
          onClick!(!value);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          color: backgroundColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    "$number",
                    style: TextStyle(
                      color: enabled ? color : color.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      decoration: enabled ? null : TextDecoration.underline
                    ),
                  ),
                ),
              )
            ),
            if (value)
              const AspectRatio(
              aspectRatio: 1,
              child: FittedBox(fit: BoxFit.fitHeight, child: Icon(Icons.cancel_outlined))
            ),

            // CustomPaint(
            //   painter: NumberTickPainter(
            //     color: color,
            //     number: number
            //   ),
            // ),

          ],        
        ) 
      )
    );
  }
}

class NumberTickPainter extends CustomPainter{
  
  const NumberTickPainter({required this.color, required this.number});

  final Color color;
  final int number;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}