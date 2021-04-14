import 'package:clean_tdd/feature/number_trivia/presentation/bloc/bloc.dart';
import 'package:clean_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider<NumberTriviaBloc> _buildBody(BuildContext context) {
      return BlocProvider(
        create: (_) => locator<NumberTriviaBloc>(),
        child: Container(
          child: Column(
            children: [
              //Top
              Container(
                height: MediaQuery.of(context).size.height * 3,
                child: Placeholder(),
              ),

              //Bottom
              Container(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Trivia"),
        ),
        body: _buildBody(context));
  }
}
