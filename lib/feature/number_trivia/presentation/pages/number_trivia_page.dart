import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/number_trivia.dart';
import '../bloc/bloc.dart';
import '../widgets/loaded_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display_widget.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    BlocProvider<NumberTriviaBloc> _buildBody(BuildContext context) {
      return BlocProvider(
        create: (_) => locator<NumberTriviaBloc>(),
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.05),
          child: Column(
            children: [
              SizedBox(
                height: mediaQuery.size.height * 0.02,
              ),
              //Top

              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  double height = mediaQuery.size.height / 3;
                  if (state is Empty)
                    return MessageDisplay(
                        height: height, message: "Start Searching!");
                  else if (state is Error)
                    return MessageDisplay(
                        height: height, message: state.message);
                  else if (state is Loading)
                    return LoadingWidget();
                  else if (state is Loaded)
                    return LoadedWidget(
                      height: height,
                      numberTrivia: NumberTrivia(
                          number: 362,
                          text:
                              "This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample trivia This is a sample triviaThis is a sample triviaThis is a sample trivia This is a sample triviaThis is a sample trivia This is a sample trivia This is a sample triviaThis is a sample triviaThis is a sample triviaThis is a sample triviaThis is a sample triviaThis is a sample triviaThis is a sample triviaThis is a sample triviaThis is a sample triviaThis is a sample triviaThis is a sample trivia"),
                    );
                  return Container();
                },
              ),

              SizedBox(
                height: mediaQuery.size.height * 0.04,
              ),
              //Bottom
              Column(
                children: [
                  Placeholder(
                    fallbackHeight: mediaQuery.size.height * 0.05,
                  ),
                  SizedBox(
                    height: mediaQuery.size.width * 0.04,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Placeholder(
                        fallbackHeight: 40,
                      )),
                      SizedBox(
                        width: mediaQuery.size.width * 0.04,
                      ),
                      Expanded(
                          child: Placeholder(
                        fallbackHeight: 40,
                      ))
                    ],
                  )
                ],
              ),
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
