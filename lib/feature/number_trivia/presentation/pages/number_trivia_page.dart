import 'package:clean_tdd/feature/number_trivia/presentation/bloc/bloc.dart';
import 'package:clean_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  else if (state is Loaded) return LoadedWidget();
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
                    fallbackHeight: mediaQuery.size.height / 2.5,
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

class MessageDisplay extends StatelessWidget {
  final String message;
  final double height;
  const MessageDisplay({Key key, this.height, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        height: height,
        child: Text("Start Searching",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final double height;
  const LoadingWidget({
    Key key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: height,
        child: CircularProgressIndicator());
  }
}

class LoadedWidget extends StatelessWidget {
  final String message;
  final double height;
  const LoadedWidget({Key key, this.height, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        height: height,
        child: Text("Start Searching",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
