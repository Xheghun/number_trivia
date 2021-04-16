import 'package:clean_tdd/feature/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaController extends StatefulWidget {
  @override
  _TriviaControllerState createState() => _TriviaControllerState();
}

class _TriviaControllerState extends State<TriviaController> {
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    dispatchConcrete() {
      BlocProvider.of<NumberTriviaBloc>(context)
          .add(GetTriviaForConcreteNumber(_controller.text));
      _controller.clear();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Enter any number'),
            onSubmitted: (_) => dispatchConcrete(),
          ),
          SizedBox(
            height: mediaQuery.size.width * 0.04,
          ),
          Container(
            width: mediaQuery.size.width,
            margin:
                EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.2),
            child: ElevatedButton(
              onPressed: () => dispatchConcrete(),
              child: Text('Search', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
  }
}
