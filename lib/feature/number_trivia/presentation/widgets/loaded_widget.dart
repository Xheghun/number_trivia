import '../../domain/entities/number_trivia.dart';
import 'package:flutter/material.dart';

class LoadedWidget extends StatelessWidget {
  final NumberTrivia numberTrivia;
  final double height;
  const LoadedWidget({Key key, this.height, this.numberTrivia})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      child: Column(
        children: [
          Text(
            "${numberTrivia.number}",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(numberTrivia.text,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
