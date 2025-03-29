import 'package:flutter/material.dart';
import 'package:frivia/provider/game_provider.dart';
import 'package:frivia/utility/utils.dart';
import 'package:frivia/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class GamePage extends StatelessWidget {
  late double _deviceWidth;
  late double _deviceHeight;
  GamePageProvider? gamePageProvider;
  late BuildContext _context;
  late String difficulty;
  late int numberOfQuestions;
  int? categoryItem;

  GamePage({
    super.key,
    required this.difficulty,
    required this.numberOfQuestions,
    this.categoryItem,
  });

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    _context = context;

    return ChangeNotifierProvider(
      create:
          (ctx) => GamePageProvider(
            context: ctx,
            difficulty: difficulty,
            max: numberOfQuestions,
            categoryItem: categoryItem,
          ),
      builder: (ctx, widget) => _buildUi(),
    );
  }

  Widget _buildUi() {
    return Scaffold(appBar: appBarWidget(_context), body: _gameUi());
  }

  Widget _gameUi() {
    return Builder(
      builder: (context) {
        gamePageProvider = context.watch<GamePageProvider>();
        if (gamePageProvider != null && gamePageProvider!.questions != null) {
          List<String> choices = gamePageProvider!.getChoices();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 10,
                children: [
                  _showQuestionCount(),
                  _showQuestion(),
                  Column(
                    spacing: 5,
                    children:
                        choices.map((value) {
                          return _customButton(
                            text: value,
                            onClick: () {
                              _chooseAnswer(value);
                            },
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  String unescapeHtml(String text) {
    Map<String, String> htmlEntities = {
      '&lt;': '<',
      '&gt;': '>',
      '&amp;': '&',
      '&quot;': '"',
      '&#39;': "'",
      '&apos;': "'",
    };

    htmlEntities.forEach((entity, character) {
      text = text.replaceAll(entity, character);
    });

    return text;
  }

  Widget _showQuestion() {
    String question = gamePageProvider!.getQuestion();
    question = unescapeHtml(question);

    return Expanded(
      child: Center(
        child: Text(
          question,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _customButton({required String text, required Function onClick}) {
    text = unescapeHtml(text);
    return Container(
      width: _deviceWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorScheme.fromSeed(seedColor: Colors.blue).primary,
      ),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 20),
        onPressed: () {
          onClick();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: ColorScheme.fromSeed(seedColor: Colors.blue).onPrimary,
          ),
        ),
      ),
    );
  }

  void _chooseAnswer(String yourChoice) {
    bool isCorrect = gamePageProvider!.checkAnswer(yourChoice);
    bool isGameEnd = gamePageProvider!.index == gamePageProvider!.max - 1;
    _showGoNextDialog(isCorrect, isGameEnd);
  }

  void _showGoNextDialog(bool isCorrect, bool isGameEnd) {
    showDialog(
      context: _context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor:
              isCorrect
                  ? ColorScheme.of(_context).primary
                  : ColorScheme.of(_context).error,
          title: Text(
            style: TextStyle(color: ColorScheme.of(_context).onPrimary),
            isCorrect ? "CORRECT" : "WRONG",
          ),
          content: Text(
            isGameEnd
                ? "You have reached end of the game. Your have scored ${gamePageProvider!.score} out of ${gamePageProvider!.max}.\nThe correct answer for the last question is ${gamePageProvider!.getCorrectAnswer().toUpperCase()}."
                : "Correct answer is ${gamePageProvider!.getCorrectAnswer().toUpperCase()}",

            style: TextStyle(color: ColorScheme.of(_context).onPrimary),
          ),
          actions: [
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: ColorScheme.of(_context).errorContainer,
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(ctx);
              },
              child: Text(
                "EXIT",
                style: TextStyle(
                  color: ColorScheme.of(_context).onErrorContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            isGameEnd
                ? SizedBox()
                : MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: ColorScheme.of(_context).primaryContainer,
                  onPressed: () {
                    gamePageProvider!.nextGame();
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    "NEXT",
                    style: TextStyle(
                      color: ColorScheme.of(_context).onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }

  _showQuestionCount() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorScheme.of(_context).primary,
      ),
      margin: EdgeInsets.only(top: 10),
      child: Text(
        "${gamePageProvider!.index + 1}/${gamePageProvider!.max}",
        style: TextStyle(color: ColorScheme.of(_context).onPrimary),
      ),
    );
  }
}
