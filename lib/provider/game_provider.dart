import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frivia/services/WebService.dart';
import 'package:get_it/get_it.dart';

class GamePageProvider extends ChangeNotifier {
  BuildContext context;
  List? questions;
  int index = 0;
  int max;
  int score = 0;
  int? categoryItem;

  GamePageProvider({
    required this.context,
    String difficulty = "easy",
    this.max = 5,
    this.categoryItem
  }) {
    loadQuizzes(difficulty, max, categoryItem);
  }

  Future<void> loadQuizzes(String difficulty, int numberOfQuestions, int? categoryItem) async {
    WebService webService = GetIt.instance.get();
    String data = await webService
        .loadUrl(difficulty, numberOfQuestions, categoryItem)
        .then((response) => response.toString());
    Map map = jsonDecode(data);
    questions = map['results'];
    max = numberOfQuestions;
    notifyListeners();
  }

  String getQuestion() {
    return questions![index]['question'];
  }

  List<String> getChoices() {
    Map question = questions![index];
    List<String> choices = [
      ...question['incorrect_answers'],
      question['correct_answer'],
    ];
    choices.shuffle(Random());
    return choices;
  }

  String getCorrectAnswer() {
    return questions![index]['correct_answer'];
  }

  bool checkAnswer(String yourChoice) {
    bool isCorrect = getCorrectAnswer() == yourChoice;
    if (isCorrect) score++;
    return isCorrect;
  }

  void nextGame() {
    index++;
    notifyListeners();
  }
}
