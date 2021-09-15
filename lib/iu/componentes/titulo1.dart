import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Titulo1 extends StatelessWidget {
  final String texto;

  const Titulo1({@required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto.toUpperCase(),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
