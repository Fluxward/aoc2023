import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'data.dart';

final width = 101;
final height = 103;

List<List<bool>> grid(int step) {
  List<List<bool>> ret = List.generate(height, (_) => List.filled(width, false));

  for (List<int> l in robots) {

    int x = (l[0] + l[2] * step) % width;
    int y = (l[1] + l[3] * step) % height;

    while (x < 0) x += width;
    while (y < 0) y += height;

    ret[y][x] = true; 
  }

  return ret;
}

class Plotter extends CustomPainter {
  final List<List<bool>> _g;
  int step;

  Plotter(this.step) : _g = grid(step) {print("Repainting!");}

  @override
  void paint(Canvas canvas, Size size) {
    //canvas.drawColor(Colors.white, BlendMode.clear);
    double hGrad = size.height / height;
    double wGrad = size.width / width;
    print(step);
    _g.forEachIndexed((r, l) => l.forEachIndexed((c, e) {
          if (!e) return;
          Rect rect = Offset(hGrad * c, wGrad * r) & Size(wGrad, hGrad);
          canvas.drawRect(rect, Paint()..color = Colors.green);
        }));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
    //return oldDelegate is! Plotter || oldDelegate._step != _step;
  }
}
