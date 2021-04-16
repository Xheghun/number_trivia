import 'package:clean_tdd/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Widget _buildBody(NumberTriviaState state) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.05),
        child: Column(
          children: [
            SizedBox(
              height: mediaQuery.size.height * 0.02,
            ),
            //Top

            Builder(
              builder: (context) {
                double height = mediaQuery.size.height * 0.2;
                if (state is Empty)
                  return MessageDisplay(
                      height: height, message: "Start Searching!");
                else if (state is Error)
                  return MessageDisplay(height: height, message: state.message);
                else if (state is Loading)
                  return LoadingWidget();
                else if (state is Loaded)
                  return LoadedWidget(
                    height: height,
                    numberTrivia: state.trivia,
                  );
                return Container();
              },
            ),

            SizedBox(
              height: mediaQuery.size.height * 0.04,
            ),
            //Bottom
            TriviaController(),
          ],
        ),
      );
    }

    return BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              BlocProvider.of<NumberTriviaBloc>(context)
                  .add(GetTriviaForRandomNumber());
            },
            child: Icon(Icons.adjust, color: Colors.black),
          ),
          appBar: AppBar(
            title: Text("Trivia"),
          ),
          body: SingleChildScrollView(
            child: _buildBody(state),
          ),
        );
      },
    );
  }
}
